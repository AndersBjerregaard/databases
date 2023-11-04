--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: constraints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.constraints (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    variety character varying(255) NOT NULL
);


ALTER TABLE public.constraints OWNER TO postgres;

--
-- Name: constraints_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.constraints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.constraints_id_seq OWNER TO postgres;

--
-- Name: constraints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.constraints_id_seq OWNED BY public.constraints.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    price double precision NOT NULL
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- Name: materials_constraints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials_constraints (
    material_id integer NOT NULL,
    constraint_id integer NOT NULL
);


ALTER TABLE public.materials_constraints OWNER TO postgres;

--
-- Name: materials_constraints_constraint_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_constraints_constraint_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_constraints_constraint_id_seq OWNER TO postgres;

--
-- Name: materials_constraints_constraint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_constraints_constraint_id_seq OWNED BY public.materials_constraints.constraint_id;


--
-- Name: materials_constraints_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_constraints_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_constraints_material_id_seq OWNER TO postgres;

--
-- Name: materials_constraints_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_constraints_material_id_seq OWNED BY public.materials_constraints.material_id;


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_id_seq OWNER TO postgres;

--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    totalprice double precision NOT NULL,
    totalproductiontime double precision NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: pizzas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizzas (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    productiontime double precision NOT NULL,
    price double precision NOT NULL,
    pizzasize_id integer NOT NULL,
    pizzastyle_id integer NOT NULL
);


ALTER TABLE public.pizzas OWNER TO postgres;

--
-- Name: pizzas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_id_seq OWNER TO postgres;

--
-- Name: pizzas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_id_seq OWNED BY public.pizzas.id;


--
-- Name: pizzas_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizzas_materials (
    pizza_id integer NOT NULL,
    material_id integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.pizzas_materials OWNER TO postgres;

--
-- Name: pizzas_materials_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_materials_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_materials_material_id_seq OWNER TO postgres;

--
-- Name: pizzas_materials_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_materials_material_id_seq OWNED BY public.pizzas_materials.material_id;


--
-- Name: pizzas_materials_pizza_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_materials_pizza_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_materials_pizza_id_seq OWNER TO postgres;

--
-- Name: pizzas_materials_pizza_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_materials_pizza_id_seq OWNED BY public.pizzas_materials.pizza_id;


--
-- Name: pizzas_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizzas_orders (
    order_id integer NOT NULL,
    pizza_id integer NOT NULL,
    amount integer NOT NULL,
    calculatedprice double precision NOT NULL
);


ALTER TABLE public.pizzas_orders OWNER TO postgres;

--
-- Name: pizzas_orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_orders_order_id_seq OWNER TO postgres;

--
-- Name: pizzas_orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_orders_order_id_seq OWNED BY public.pizzas_orders.order_id;


--
-- Name: pizzas_orders_pizza_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_orders_pizza_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_orders_pizza_id_seq OWNER TO postgres;

--
-- Name: pizzas_orders_pizza_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_orders_pizza_id_seq OWNED BY public.pizzas_orders.pizza_id;


--
-- Name: pizzas_pizzasize_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_pizzasize_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_pizzasize_id_seq OWNER TO postgres;

--
-- Name: pizzas_pizzasize_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_pizzasize_id_seq OWNED BY public.pizzas.pizzasize_id;


--
-- Name: pizzas_pizzastyle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzas_pizzastyle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzas_pizzastyle_id_seq OWNER TO postgres;

--
-- Name: pizzas_pizzastyle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzas_pizzastyle_id_seq OWNED BY public.pizzas.pizzastyle_id;


--
-- Name: pizzasizes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizzasizes (
    id integer NOT NULL,
    volume character varying(255) NOT NULL,
    pricemultiplier double precision NOT NULL,
    productionmultiplier double precision NOT NULL
);


ALTER TABLE public.pizzasizes OWNER TO postgres;

--
-- Name: pizzasizes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzasizes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzasizes_id_seq OWNER TO postgres;

--
-- Name: pizzasizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzasizes_id_seq OWNED BY public.pizzasizes.id;


--
-- Name: pizzastyles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizzastyles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    pricemultiplier double precision NOT NULL,
    productionmultiplier double precision NOT NULL
);


ALTER TABLE public.pizzastyles OWNER TO postgres;

--
-- Name: pizzastyles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pizzastyles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pizzastyles_id_seq OWNER TO postgres;

--
-- Name: pizzastyles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pizzastyles_id_seq OWNED BY public.pizzastyles.id;


--
-- Name: constraints id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.constraints ALTER COLUMN id SET DEFAULT nextval('public.constraints_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Name: materials_constraints material_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_constraints ALTER COLUMN material_id SET DEFAULT nextval('public.materials_constraints_material_id_seq'::regclass);


--
-- Name: materials_constraints constraint_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_constraints ALTER COLUMN constraint_id SET DEFAULT nextval('public.materials_constraints_constraint_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: pizzas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas ALTER COLUMN id SET DEFAULT nextval('public.pizzas_id_seq'::regclass);


--
-- Name: pizzas pizzasize_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas ALTER COLUMN pizzasize_id SET DEFAULT nextval('public.pizzas_pizzasize_id_seq'::regclass);


--
-- Name: pizzas pizzastyle_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas ALTER COLUMN pizzastyle_id SET DEFAULT nextval('public.pizzas_pizzastyle_id_seq'::regclass);


--
-- Name: pizzas_materials pizza_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_materials ALTER COLUMN pizza_id SET DEFAULT nextval('public.pizzas_materials_pizza_id_seq'::regclass);


--
-- Name: pizzas_materials material_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_materials ALTER COLUMN material_id SET DEFAULT nextval('public.pizzas_materials_material_id_seq'::regclass);


--
-- Name: pizzas_orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_orders ALTER COLUMN order_id SET DEFAULT nextval('public.pizzas_orders_order_id_seq'::regclass);


--
-- Name: pizzas_orders pizza_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_orders ALTER COLUMN pizza_id SET DEFAULT nextval('public.pizzas_orders_pizza_id_seq'::regclass);


--
-- Name: pizzasizes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzasizes ALTER COLUMN id SET DEFAULT nextval('public.pizzasizes_id_seq'::regclass);


--
-- Name: pizzastyles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzastyles ALTER COLUMN id SET DEFAULT nextval('public.pizzastyles_id_seq'::regclass);


--
-- Data for Name: constraints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.constraints (id, name, variety) FROM stdin;
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, name, price) FROM stdin;
\.


--
-- Data for Name: materials_constraints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials_constraints (material_id, constraint_id) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, totalprice, totalproductiontime) FROM stdin;
\.


--
-- Data for Name: pizzas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pizzas (id, name, productiontime, price, pizzasize_id, pizzastyle_id) FROM stdin;
\.


--
-- Data for Name: pizzas_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pizzas_materials (pizza_id, material_id, quantity) FROM stdin;
\.


--
-- Data for Name: pizzas_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pizzas_orders (order_id, pizza_id, amount, calculatedprice) FROM stdin;
\.


--
-- Data for Name: pizzasizes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pizzasizes (id, volume, pricemultiplier, productionmultiplier) FROM stdin;
\.


--
-- Data for Name: pizzastyles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pizzastyles (id, name, pricemultiplier, productionmultiplier) FROM stdin;
\.


--
-- Name: constraints_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.constraints_id_seq', 1, false);


--
-- Name: materials_constraints_constraint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_constraints_constraint_id_seq', 1, false);


--
-- Name: materials_constraints_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_constraints_material_id_seq', 1, false);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: pizzas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_id_seq', 1, false);


--
-- Name: pizzas_materials_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_materials_material_id_seq', 1, false);


--
-- Name: pizzas_materials_pizza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_materials_pizza_id_seq', 1, false);


--
-- Name: pizzas_orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_orders_order_id_seq', 1, false);


--
-- Name: pizzas_orders_pizza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_orders_pizza_id_seq', 1, false);


--
-- Name: pizzas_pizzasize_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_pizzasize_id_seq', 1, false);


--
-- Name: pizzas_pizzastyle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzas_pizzastyle_id_seq', 1, false);


--
-- Name: pizzasizes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzasizes_id_seq', 1, false);


--
-- Name: pizzastyles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pizzastyles_id_seq', 1, false);


--
-- Name: constraints constraints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.constraints
    ADD CONSTRAINT constraints_pkey PRIMARY KEY (id);


--
-- Name: materials_constraints materials_constraints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_constraints
    ADD CONSTRAINT materials_constraints_pkey PRIMARY KEY (material_id, constraint_id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pizzas_materials pizzas_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_materials
    ADD CONSTRAINT pizzas_materials_pkey PRIMARY KEY (pizza_id, material_id);


--
-- Name: pizzas_orders pizzas_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_orders
    ADD CONSTRAINT pizzas_orders_pkey PRIMARY KEY (pizza_id, order_id);


--
-- Name: pizzas pizzas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas
    ADD CONSTRAINT pizzas_pkey PRIMARY KEY (id);


--
-- Name: pizzasizes pizzasizes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzasizes
    ADD CONSTRAINT pizzasizes_pkey PRIMARY KEY (id);


--
-- Name: pizzastyles pizzastyles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzastyles
    ADD CONSTRAINT pizzastyles_pkey PRIMARY KEY (id);


--
-- Name: materials_constraints fk_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_constraints
    ADD CONSTRAINT fk_constraint FOREIGN KEY (constraint_id) REFERENCES public.constraints(id);


--
-- Name: materials_constraints fk_material; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_constraints
    ADD CONSTRAINT fk_material FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: pizzas_materials fk_material; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_materials
    ADD CONSTRAINT fk_material FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: pizzas_orders fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_orders
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: pizzas_materials fk_pizza; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_materials
    ADD CONSTRAINT fk_pizza FOREIGN KEY (pizza_id) REFERENCES public.pizzas(id);


--
-- Name: pizzas_orders fk_pizza; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas_orders
    ADD CONSTRAINT fk_pizza FOREIGN KEY (pizza_id) REFERENCES public.pizzas(id);


--
-- Name: pizzas fk_pizzasize; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas
    ADD CONSTRAINT fk_pizzasize FOREIGN KEY (pizzasize_id) REFERENCES public.pizzasizes(id);


--
-- Name: pizzas fk_pizzastyle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizzas
    ADD CONSTRAINT fk_pizzastyle FOREIGN KEY (pizzastyle_id) REFERENCES public.pizzastyles(id);


--
-- PostgreSQL database dump complete
--

