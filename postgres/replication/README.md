# Replication

*Working directory should be in https://github.com/AndersBjerregaard/databases/tree/master/postgres/replication*

Create a network

```
docker network create postgres
```

## Primary Instance

Start instance 1. This will be your primary instance. Or your *source* in a *source*-*replica* orchestration.

The archive folder will be looked at further down.

```
docker run -it --rm --name postgres-1 \
--net postgres \
-e POSTGRES_USER=postgresadmin \
-e POSTGRES_PASSWORD=admin123 \
-e POSTGRES_DB=postgresdb \
-e PGDATA="/data" \
-v ${PWD}/postgres-1/pgdata:/data \
-v ${PWD}/postgres-1/config:/config \
-v ${PWD}/postgres-1/archive:/mnt/server/archive \
-p 5000:5432 \
postgres:15.0 -c 'config_file=/config/postgresql.conf'
```

## Create Replication User

You need a user that has permissions to do replication.
The `-c` option is the connection limit for that user that we want to allow. So we allow up to 5 connections for that user. The `--replication` option tells Postgres that this user needs replication capabilities.
While the last argument, is just the username for the created user "replicationUser".
```
docker exec -it postgres-1 bash

createuser -U postgresadmin -P -c 5 --replication replicationUser

exit
```

Now we need to allow this user to access the database.
This is done by editing the access configuration file.
This file is located in the postgres configuration directory under the name `pg_hba.conf`.

In this file, you want to add a new line for the user. 
The `METHOD` is the password format.
So the file should look something like this:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

host     replication     replicationUser         0.0.0.0/0        md5

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            trust
host    replication     all             ::1/128                 trust

host all all all scram-sha-256

```

# Write-Ahead Log

Write-Ahead logging is a feature designed to protect data integrity.
When Postgres does a transaction, it will write it to a transaction log and flush it to disk. And it will not consider the transaction complete until it's been written to disk. This functionality is called *Write-Ahead Logging*.
This is the core mechanism used for replication.
The official Postgres documentation for Write-Ahead Logging can be found [here](https://www.postgresql.org/docs/current/wal-intro.html).

The reasoning for the transaction not being complete until the disk write has been completed, is that if there's a crash in the system; the database can be recovered from the transaction log. Hence it is "writing ahead".

There are two main configurations to consider when enabling Write-Ahead Logging for postgres. One is [wal_level](https://www.postgresql.org/docs/current/runtime-config-wal.html), the other is [max_wal_senders](https://www.postgresql.org/docs/current/runtime-config-replication.html).
In summary for `wal_level`: Determines how much information is written to the WAL. The default value is replica, which writes enough data to support WAL archiving and replication, including running read-only queries on a standby server.
In summary for `max_wal_senders`: Specifies the maximum number of concurrent connections from standby servers or streaming base backup clients (i.e., the maximum number of simultaneously running WAL sender processes).

For this example, we will go with these settings:

```
wal_level = replica
max_wal_senders = 3
```

# Enable Archiving

Archiving is the process of archiving the transaction logs. So that Postgres can be recovered from any point in time, in case of failure. It's also important to archive this to a *docker volume* so that it's persisted. In the case where our container dies and restarts, the archive isn't lost.
The official documentation for `archive_mode` for postgres can be found [here](https://www.postgresql.org/docs/current/runtime-config-wal.html#GUC-ARCHIVE-MODE).

For this example, it's as simple as enabling archiving. And setting the `archive_command`. Which is a command that postgres will run every time a WAL segment has been written to the log. The official documentation states: "`archive_command` is the local shell command to execute to archive a complete WAL file segment". The parameter `%p` is replaced by the path name of the file to archive, and the parameter `%f` is replaced by only the file name.

For this command, we will run a command to test the path, and copy the file to the archive directory:

```
archive_mode = on
archive_command = 'test ! -f /mnt/server/archive/%f && cp %p /mnt/server/archive/%f'
```

Both the settings of **archiving** and **WAL** settings should be inserted in the `postgresql.conf` file under the postgres configuration directory. So the file should look something like this:

```
# -----------------------------
# PostgreSQL configuration file
# -----------------------------
#

data_directory = '/data'
hba_file = '/config/pg_hba.conf'
ident_file = '/config/pg_ident.conf'

port = 5432
listen_addresses = '*'
max_connections = 100
shared_buffers = 128MB
dynamic_shared_memory_type = posix
max_wal_size = 1GB
min_wal_size = 80MB
log_timezone = 'Etc/UTC'
datestyle = 'iso, mdy'
timezone = 'Etc/UTC'

#locale settings
lc_messages = 'en_US.utf8'                      # locale for system error message
lc_monetary = 'en_US.utf8'                      # locale for monetary formatting
lc_numeric = 'en_US.utf8'                       # locale for number formatting
lc_time = 'en_US.utf8'                          # locale for time formatting

default_text_search_config = 'pg_catalog.english'

#replication
wal_level = replica
archive_mode = on
archive_command = 'test ! -f /mnt/server/archive/%f && cp %p /mnt/server/archive/%f'
max_wal_senders = 3
```

# Testing

A test to ensure that archiving is happening correctly. It could be as simple as killing the container and restarting it.  This will force the database to write to the WAL so it archives the data. And you should see data in the `postgres-1/archive` folder.

# Base Backup

The [pg_basebackup](https://www.postgresql.org/docs/current/app-pgbasebackup.html) is a tool used to create standby instances and backup postgres databases. It will connect to your primary instance as a replication user. And then take a backup and restore it to a data folder. This data information will almost be identical to the primary instance's, but this data folder will be ready and set up to receive replica requests from the primary instance.

For this example, we¨ll take a backup of our primary data folder and create a new data directory. Then we'll take this newly created data directory and make a new Docker volume for our secondary standby instance. Once this secondary standby instance starts up it'll automatically start to read the transaction log of the primary server: Starting the replication process.
This database will technically run as a readonly instance.
Because of this purpose, we're not interested in running a postgres database as an entrypoint for this new container. But instead, override the entrypoint in order to get access to the `pg_basebackup` utility. Note that we also mount our blank data directory as we will make a new backup in there:

```
docker run -it --rm \
--net postgres \
-v ${PWD}/postgres-2/pgdata:/data \
--entrypoint /bin/bash postgres:15.0
```

Take the backup by logging into `postgres-1` with our `replicationUser` and writing the backup to `/data`.
The `-h` or `--host` option specifies the host name of the machine on which the server is running. If the value begins with a slash, it is used as the directory for a Unix domain socket. The default is taken from the PGHOST environment variable, if set, else a Unix domain socket connection is attempted.
The `-p` or `--port` option specifies the TCP port.
The `-D` or `--pgdata` option sets the target directory to write the output to. pg_basebackup will create this directory (and any missing parent directories) if it does not exist. If it already exists, it must be empty. When the backup is in tar format, the target directory may be specified as - (dash), causing the tar file to be written to stdout. This option is required.
The `-U` or `--username` option specifies the user name to connect as.
The `-R` or `--write-recovery-conf` option creates a *standby.signal* file and appends connection settings to the `postgresql.auto.conf` file in the target directory (or within the base archive file when using tar format). This eases setting up a standby server using the results of the backup. The `postgresql.auto.conf` file will record the connection settings and, if specified, the replication slot that pg_basebackup is using, so that streaming replication will use the same settings later on.
The `-Xs` option specifies WAL streaming mode.
The `-Fp` option is an abbreviation of `--format=plain`. Which states to write the output as plain files, with the same layout as the source server's data directory and tablespaces. When the cluster has no additional tablespaces, the whole database will be placed in the target directory. If the cluster contains additional tablespaces, the main data directory will be placed in the target directory, but all other tablespaces will be placed in the same absolute path as they have on the source server. (See --tablespace-mapping to change that.) This is the default format.

```
pg_basebackup -h postgres-1 -p 5432 -U replicationUser -D /data/ -Fp -Xs -R
```

This command takes a bit of time to run. But if you're monitoring your primary instance. You should see in its logs that it's been forced to wait because of this command above:

```
2023-12-09 22:00:32.474 UTC [25] LOG:  checkpoint starting: force wait
```

If you take a look in the `pgdata` folder of the `postgres-2` folder. You should see a lot of the same information as the `postgres-1` folder has. However, this instance has replication and streaming capabilities.

# Start standby instance

```
docker run -it --rm --name postgres-2 \
--net postgres \
-e POSTGRES_USER=postgresadmin \
-e POSTGRES_PASSWORD=admin123 \
-e POSTGRES_DB=postgresdb \
-e PGDATA="/data" \
-v ${PWD}/postgres-2/pgdata:/data \
-v ${PWD}/postgres-2/config:/config \
-v ${PWD}/postgres-2/archive:/mnt/server/archive \
-p 5001:5432 \
postgres:15.0 -c 'config_file=/config/postgresql.conf'
```

If you're monitoring this newly created instance, you should see some logs indicating that replication has been set up:

```
2023-12-09 22:10:22.724 UTC [28] LOG:  entering standby mode
2023-12-09 22:10:22.732 UTC [28] LOG:  redo starts at 0/4000028
2023-12-09 22:10:22.735 UTC [28] LOG:  consistent recovery state reached at 0/4000138
2023-12-09 22:10:22.735 UTC [1] LOG:  database system is ready to accept read-only connections
2023-12-09 22:10:22.746 UTC [29] LOG:  started streaming WAL from primary at 0/5000000 on timeline 1
```

# Testing Replication

To test the replication. We could create a new table in the primary instance:

```
docker exec -ti postgres-1 bash

psql --username=postgresadmin postgresdb

CREATE TABLE customers (firstname text, customer_id serial, date_created timestamp);

#show the table
\dt
```

Now log into the secondary standby instance and view the table:

```
docker exec -ti postgres-2 bash

psql --username=postgresadmin postgresdb

#show the tables
\dt
```

You should see the table in both instances.

# Failover

To simulate a failure scenario, we'll shutdown our primary instance. But Postgres doesn't have native failover built in. This is where external tools come in. Postgres has a load balancer tool that can help with automatic failover. To simulate the failure, we'll manually failover using the [pg_ctl](https://www.postgresql.org/docs/current/app-pg-ctl.html) tool. When the `postgres-1` instance fails, we would want our standby server to be promoted to a primary server. This tool will essentially run against the standby server. And turn it from a readonly instance to a read-write instance. So that it can be used as a primary instance.
You will have to build a new standby server just like it was shown in the sections above. And you'd also need to configure replication on the new primary, same as above.

Stop the primary server to simulate failure:
```
docker rm -f postgres-1
```

Log into the `postgres-2` instance and promote it to primary:

```
docker exec -it postgres-2 bash

# log into database cli tool
psql --username=postgresadmin postgresdb

# confirm we cannot create a table as its a stand-by server
CREATE TABLE customers (firstname text, customer_id serial, date_created timestamp);

# exit out of database cli tool
\q

# run pg_ctl as postgres user (cannot be run as root!)
runuser -u postgres -- pg_ctl promote

# log into database cli tool
psql --username=postgresadmin postgresdb

# confirm we can create a table as its a primary server
CREATE TABLE customers (firstname text, customer_id serial, date_created timestamp);
```

You should see outputs from these commands looking something like this:

```
waiting for server to promote.... done
server promoted
ERROR:  relation "customers" already exists
```
