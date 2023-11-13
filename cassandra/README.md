# Info

Normally you have a image running the cassandra server itself.
And another image being responsible for querying the server.
Therefore most tutorials show the cassandra server being run with a network established.

```
docker network create --driver bridge cassandra
```

```
docker run --rm -d --name cassandra --hostname cassandra --network cassandra cassandra
```

## Create some data

Cassandra Query Language (CQL) is usually consumed through its CQLSH tool.

Here is some sample data you can put into a `.cql` file:
```
-- Create a keyspace
CREATE KEYSPACE IF NOT EXISTS store WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

-- Create a table
CREATE TABLE IF NOT EXISTS store.shopping_cart (
userid text PRIMARY KEY,
item_count int,
last_update_timestamp timestamp
);

-- Insert some data
INSERT INTO store.shopping_cart
(userid, item_count, last_update_timestamp)
VALUES ('9876', 2, toTimeStamp(now()));
INSERT INTO store.shopping_cart
(userid, item_count, last_update_timestamp)
VALUES ('1234', 5, toTimeStamp(now()));
```

## Load the data with CQLSH

```
docker run --rm --network cassandra -v "$(pwd)/data.cql:/scripts/data.cql" -e CQLSH_HOST=cassandra -e CQLSH_PORT=9042 -e CQLVERSION=3.4.6 nuvo/docker-cqlsh
```

Note: The cassandra server itself (the first docker run command you ran) takes a few seconds to start up. The above command will throw an error if the server hasn’t finished its init sequence yet, so give it a few seconds to spin up.
