--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-04-15 20:25:28

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 17416)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 862 (class 1247 OID 17438)
-- Name: ClaimPriority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ClaimPriority" AS ENUM (
    'Normal',
    'High'
);


ALTER TYPE public."ClaimPriority" OWNER TO postgres;

--
-- TOC entry 859 (class 1247 OID 17427)
-- Name: ClaimStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ClaimStatus" AS ENUM (
    'Pending',
    'Under_Review',
    'Approved',
    'Denied',
    'Settled'
);


ALTER TYPE public."ClaimStatus" OWNER TO postgres;

--
-- TOC entry 871 (class 1247 OID 17482)
-- Name: Role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Role" AS ENUM (
    'client',
    'admin'
);


ALTER TYPE public."Role" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 17444)
-- Name: Claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Claim" (
    id integer NOT NULL,
    claim_type text NOT NULL,
    incident_description text NOT NULL,
    status public."ClaimStatus" DEFAULT 'Pending'::public."ClaimStatus" NOT NULL,
    priority public."ClaimPriority" DEFAULT 'Normal'::public."ClaimPriority" NOT NULL,
    user_id integer NOT NULL,
    review_comment text,
    reviewed_at timestamp(3) without time zone,
    reviewed_by integer,
    payment_reference text,
    settlement_amount double precision,
    settlement_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Claim" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 20032)
-- Name: ClaimDocument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ClaimDocument" (
    id integer NOT NULL,
    claim_id integer NOT NULL,
    file_name text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."ClaimDocument" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 20031)
-- Name: ClaimDocument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ClaimDocument_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ClaimDocument_id_seq" OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 226
-- Name: ClaimDocument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ClaimDocument_id_seq" OWNED BY public."ClaimDocument".id;


--
-- TOC entry 218 (class 1259 OID 17443)
-- Name: Claim_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Claim_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Claim_id_seq" OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 218
-- Name: Claim_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Claim_id_seq" OWNED BY public."Claim".id;


--
-- TOC entry 223 (class 1259 OID 18073)
-- Name: EmailLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EmailLog" (
    id integer NOT NULL,
    recipient text NOT NULL,
    subject text NOT NULL,
    body text NOT NULL,
    status text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    error_message text
);


ALTER TABLE public."EmailLog" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18072)
-- Name: EmailLog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EmailLog_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."EmailLog_id_seq" OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 222
-- Name: EmailLog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EmailLog_id_seq" OWNED BY public."EmailLog".id;


--
-- TOC entry 221 (class 1259 OID 17456)
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role public."Role" DEFAULT 'client'::public."Role" NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18411)
-- Name: UserProfile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserProfile" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    phone text,
    address text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    nrc text NOT NULL
);


ALTER TABLE public."UserProfile" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18410)
-- Name: UserProfile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."UserProfile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."UserProfile_id_seq" OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 224
-- Name: UserProfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."UserProfile_id_seq" OWNED BY public."UserProfile".id;


--
-- TOC entry 220 (class 1259 OID 17455)
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 220
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- TOC entry 217 (class 1259 OID 17417)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- TOC entry 4777 (class 2604 OID 17447)
-- Name: Claim id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Claim" ALTER COLUMN id SET DEFAULT nextval('public."Claim_id_seq"'::regclass);


--
-- TOC entry 4787 (class 2604 OID 20035)
-- Name: ClaimDocument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ClaimDocument" ALTER COLUMN id SET DEFAULT nextval('public."ClaimDocument_id_seq"'::regclass);


--
-- TOC entry 4783 (class 2604 OID 18076)
-- Name: EmailLog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EmailLog" ALTER COLUMN id SET DEFAULT nextval('public."EmailLog_id_seq"'::regclass);


--
-- TOC entry 4781 (class 2604 OID 17459)
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- TOC entry 4785 (class 2604 OID 18414)
-- Name: UserProfile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile" ALTER COLUMN id SET DEFAULT nextval('public."UserProfile_id_seq"'::regclass);


--
-- TOC entry 4954 (class 0 OID 17444)
-- Dependencies: 219
-- Data for Name: Claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Claim" (id, claim_type, incident_description, status, priority, user_id, review_comment, reviewed_at, reviewed_by, payment_reference, settlement_amount, settlement_date, created_at) FROM stdin;
35	Water Damage	My home was flooded during the heavy rains last week. Water damaged my furniture and electronics. I’ve uploaded images and my policy documents.	Under_Review	Normal	2	\N	2025-04-15 17:44:34.092	1	\N	\N	\N	2025-04-15 17:44:14.671
34	Water Damage	I was hospitalized for a broken arm after slipping at work. I have attached medical records and my hospital bill.	Settled	Normal	2	\N	2025-04-15 17:44:42.437	1	PF-1235452	3000	2025-04-15 17:45:16.475	2025-04-15 17:43:37.521
\.


--
-- TOC entry 4962 (class 0 OID 20032)
-- Dependencies: 227
-- Data for Name: ClaimDocument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ClaimDocument" (id, claim_id, file_name, created_at) FROM stdin;
5	34	1744739017029-137563118.pdf	2025-04-15 17:43:37.534
6	35	1744739053246-864472252.pdf	2025-04-15 17:44:14.68
\.


--
-- TOC entry 4958 (class 0 OID 18073)
-- Dependencies: 223
-- Data for Name: EmailLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."EmailLog" (id, recipient, subject, body, status, created_at, error_message) FROM stdin;
1	stephenlungo99@gmail.com	Claim 1 Status Update	Your claim with ID 1 has been Denied. Comments: All documents are lost.	Failed	2025-04-15 13:05:41.672	\N
2	stephenlungo99@gmail.com	Claim 1 Status Update	Your claim with ID 1 has been Denied. Comments: All documents are lost.	Failed	2025-04-15 13:05:41.672	\N
3	stephenlungo99@gmail.com	Claim 1 Status Update	Your claim with ID 1 has been Denied. Comments: All documents are lost.	Failed	2025-04-15 13:05:41.672	\N
4	stephenlungo99@gmail.com	Claim 1 Status Update	Your claim with ID 1 has been Approved. Comments: All documents are verified.	Sent	2025-04-15 13:05:41.672	\N
5	tawila@gmail.com	Claim 1 Status Update	Your claim with ID 1 has been Approved. Comments: All documents are verified.	Sent	2025-04-15 13:05:41.672	\N
6	tawila@gmail.com	Claim 7 Status Update	Your claim with ID 7 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 12:53:12.711	\N
7	tawila@gmail.com	Claim 8 Status Update	Your claim with ID 8 has been Approved. Comments: No comments provided.	Sent	2025-04-15 12:53:40.068	\N
8	stephenlungo99@gmail.com	Claim 8 Status Update	Your claim with ID 8 has been Pending. Comments: No comments provided.	Sent	2025-04-15 12:55:54.77	\N
9	stephenlungo99@gmail.com	Claim 7 Status Update	Your claim with ID 7 has been Approved. Comments: No comments provided.	Sent	2025-04-15 12:57:20.354	\N
10	stephenlungo99@gmail.com	Claim 8 Status Update	Your claim with ID 8 has been Denied. Comments: No comments provided.	Sent	2025-04-15 12:59:21.593	\N
11	stephenlungo99@gmail.com	Claim 8 Status Update	Your claim with ID 8 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 12:59:28.687	\N
12	stephenlungo99@gmail.com	Claim 8 Status Update	Your claim with ID 8 has been Approved. Comments: No comments provided.	Sent	2025-04-15 13:25:07.299	\N
13	stephenlungo99@gmail.com	Claim 9 Status Update	Your claim with ID 9 has been Approved. Comments: No comments provided.	Sent	2025-04-15 13:32:55.109	\N
14	stephenlungo99@gmail.com	Claim 9 Status Update	Your claim with ID 9 has been Approved. Comments: No comments provided.	Sent	2025-04-15 13:33:16.245	\N
15	stephenlungo99@gmail.com	Claim 13 Status Update	Your claim with ID 13 has been Pending. Comments: No comments provided.	Sent	2025-04-15 15:12:02.682	\N
16	stephenlungo99@gmail.com	Claim 13 Status Update	Your claim with ID 13 has been Approved. Comments: No comments provided.	Sent	2025-04-15 15:12:07.597	\N
17	stephenlungo99@gmail.com	Claim 13 Status Update	Your claim with ID 13 has been Pending. Comments: No comments provided.	Sent	2025-04-15 15:12:15.755	\N
18	stephenlungo99@gmail.com	Claim 13 Status Update	Your claim with ID 13 has been Approved. Comments: No comments provided.	Sent	2025-04-15 15:12:31.904	\N
19	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 15:32:06.287	\N
20	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Pending. Comments: No comments provided.	Sent	2025-04-15 15:32:20.953	\N
21	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 15:32:33.926	\N
22	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Pending. Comments: No comments provided.	Sent	2025-04-15 15:33:35.982	\N
23	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 15:34:44.568	\N
24	stephenlungo99@gmail.com	Claim 14 Status Update	Your claim with ID 14 has been Pending. Comments: No comments provided.	Sent	2025-04-15 15:36:28.048	\N
25	stephenlungo99@gmail.com	Claim 33 Status Update	Your claim with ID 33 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 17:29:29.656	\N
26	tawila@gmail.com	Claim 15 Status Update	Your claim with ID 15 has been Approved. Comments: No comments provided.	Sent	2025-04-15 17:40:48.503	\N
27	tawila@gmail.com	Claim 35 Status Update	Your claim with ID 35 has been Under_Review. Comments: No comments provided.	Sent	2025-04-15 17:44:37.39	\N
28	tawila@gmail.com	Claim 34 Status Update	Your claim with ID 34 has been Approved. Comments: No comments provided.	Sent	2025-04-15 17:44:45.447	\N
\.


--
-- TOC entry 4956 (class 0 OID 17456)
-- Dependencies: 221
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, email, password, role) FROM stdin;
1	stephenlungo99@gmail.com	$2b$10$Oshs77OLOs2HWQPyXixW7eCJN5PCJfQjifgMcUDHYJiiPxfc/NNHy	admin
2	tawila@gmail.com	$2b$10$0UgUeX0VbmmoC06TDqjTpuEv/u4k8Oazio4Y5dqZuJhfw3oR7NL3K	client
\.


--
-- TOC entry 4960 (class 0 OID 18411)
-- Dependencies: 225
-- Data for Name: UserProfile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserProfile" (id, user_id, first_name, last_name, phone, address, created_at, updated_at, nrc) FROM stdin;
2	1	Stephen	Lungo	+260976956066	708 Kabulonga, Lusaka	2025-04-15 11:30:34.929	2025-04-15 11:30:34.929	150895/78/1
3	2	Tawila	Lungo	+260969569066	708 Itawa, Ndola	2025-04-15 11:35:14.103	2025-04-15 11:35:14.103	158875/78/1
\.


--
-- TOC entry 4952 (class 0 OID 17417)
-- Dependencies: 217
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
20c58d92-fbaf-40e5-8ef3-ce5e3aaa6af8	f760499c7400866066164f38df2da48892e9b3eb72957e572f92b9b2ccb5b9b1	2025-04-15 02:51:58.537049+02	20250414225301_init	\N	\N	2025-04-15 02:51:58.506573+02	1
6818707d-dafd-424d-b411-3cccabb668e0	69e832e5da887ea746ab308373bccbf844b694da5487d5b99383bcb53c56eda6	2025-04-15 02:51:58.577587+02	20250414235232_add_user_and_claim_tables_and_enums	\N	\N	2025-04-15 02:51:58.537761+02	1
b5887e55-70f3-4083-b1d0-b245ff055e2b	7d2eaf1729f74692973afdf3bd675af070c8095cce6a0747084d794fb73cefdc	2025-04-15 02:51:58.582357+02	20250415003840_add_maker_checker_fields	\N	\N	2025-04-15 02:51:58.578427+02	1
976de53f-bb67-4188-9f80-4d4e1b15c3bd	9b0b841f55c83d62a867cb78eda311a726d01768c45a7fe9695dca31cef5b881	2025-04-15 02:51:58.60666+02	20250415004906_add_client_admin_fields	\N	\N	2025-04-15 02:51:58.582831+02	1
acf517be-90d8-4652-8594-6a4dc583dfcf	ee0c8ce1070f0cdb35ce47e3f74e5fd850e54243e7e71cb9cd3604cf88d33025	2025-04-15 03:15:21.361455+02	20250415011518_add_discharge_fields	\N	\N	2025-04-15 03:15:21.355995+02	1
6a59b842-3961-442b-88c7-16e4868a341e	ee331e269da71a54dc75051a11071d13b9f6acc456cc7b9cd5450d57e9effbb6	2025-04-15 04:17:39.084814+02	20250415021736_add_email_log_table	\N	\N	2025-04-15 04:17:39.051616+02	1
33872f73-fa0c-429f-89d4-d548c4d94998	3f16107c9824ef6514a76980da5e537e83de61fe33eaff7403962628bcc8b4d6	2025-04-15 13:03:26.684975+02	20250415110324_add_user_profile	\N	\N	2025-04-15 13:03:26.639505+02	1
9d28301a-df6b-48d4-8f38-6f9d75f7ae83	a386c5ad12dda96787129a89f3604ca52cded2044026dc38d776aa443a962035	2025-04-15 13:05:41.677783+02	20250415110539_add_corrected_columns	\N	\N	2025-04-15 13:05:41.67046+02	1
7c2d8da2-122a-48e7-bb10-37e4f882551d	d1d03ab536edaf923410836e750c01905f9b7264162668310c57237b3840b97d	2025-04-15 13:29:30.716651+02	20250415112928_add_nrc	\N	\N	2025-04-15 13:29:30.712719+02	1
4785686d-36b5-4582-9d86-221269d5332d	e4423e100bdf74d62d89710e039c8bc5d0e203ac84cce9c36a46f8b0804105fa	2025-04-15 13:32:44.918238+02	20250415113242_removed_claimant_name	\N	\N	2025-04-15 13:32:44.914477+02	1
15e2dc8f-bc23-461c-824c-79db0824af9b	ad1299d61020806e564fbc39c649c3e2c091dee0ce351d7ad71219d8c47f9f97	2025-04-15 15:52:08.631443+02	20250415135206_add_claim_documents	\N	\N	2025-04-15 15:52:08.595272+02	1
cdb85d57-7837-41a6-9cb9-8b98fdc6fef3	c78a1495e24cf0bb107da5c791cc88d900d69db7a4b7c576d91706ce60aa90ca	2025-04-15 16:14:34.830732+02	20250415141432_add_removed_file_name	\N	\N	2025-04-15 16:14:34.82746+02	1
\.


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 226
-- Name: ClaimDocument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ClaimDocument_id_seq"', 6, true);


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 218
-- Name: Claim_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Claim_id_seq"', 35, true);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 222
-- Name: EmailLog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."EmailLog_id_seq"', 28, true);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 224
-- Name: UserProfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserProfile_id_seq"', 3, true);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 220
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 2, true);


--
-- TOC entry 4802 (class 2606 OID 20040)
-- Name: ClaimDocument ClaimDocument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ClaimDocument"
    ADD CONSTRAINT "ClaimDocument_pkey" PRIMARY KEY (id);


--
-- TOC entry 4792 (class 2606 OID 17454)
-- Name: Claim Claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Claim"
    ADD CONSTRAINT "Claim_pkey" PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 18081)
-- Name: EmailLog EmailLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EmailLog"
    ADD CONSTRAINT "EmailLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 18419)
-- Name: UserProfile UserProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile"
    ADD CONSTRAINT "UserProfile_pkey" PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 17463)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- TOC entry 4790 (class 2606 OID 17425)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4800 (class 1259 OID 18420)
-- Name: UserProfile_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserProfile_user_id_key" ON public."UserProfile" USING btree (user_id);


--
-- TOC entry 4793 (class 1259 OID 17464)
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- TOC entry 4806 (class 2606 OID 20041)
-- Name: ClaimDocument ClaimDocument_claim_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ClaimDocument"
    ADD CONSTRAINT "ClaimDocument_claim_id_fkey" FOREIGN KEY (claim_id) REFERENCES public."Claim"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4803 (class 2606 OID 17476)
-- Name: Claim Claim_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Claim"
    ADD CONSTRAINT "Claim_reviewed_by_fkey" FOREIGN KEY (reviewed_by) REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4804 (class 2606 OID 17465)
-- Name: Claim Claim_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Claim"
    ADD CONSTRAINT "Claim_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4805 (class 2606 OID 18421)
-- Name: UserProfile UserProfile_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile"
    ADD CONSTRAINT "UserProfile_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-04-15 20:25:29

--
-- PostgreSQL database dump complete
--

