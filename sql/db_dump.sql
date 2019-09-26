--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

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

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activist_organization; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.activist_organization (
    name character(7),
    id real NOT NULL,
    address character(28),
    rent real
);


ALTER TABLE public.activist_organization OWNER TO ubangi;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.employees (
    employee_id real NOT NULL,
    first_name character(20),
    last_name character(20),
    salary real,
    org_id real,
    camp_id real
);


ALTER TABLE public.employees OWNER TO ubangi;

--
-- Name: allemployeesgng; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.allemployeesgng AS
 SELECT employees.first_name,
    employees.last_name,
    employees.employee_id
   FROM public.employees
  WHERE (employees.org_id = ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar)));


ALTER TABLE public.allemployeesgng OWNER TO ubangi;

--
-- Name: areas; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.areas (
    area_name character(20) NOT NULL,
    severity character(10) NOT NULL,
    org_id real
);


ALTER TABLE public.areas OWNER TO ubangi;

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.campaigns (
    camp_name character(24),
    campaign_id real NOT NULL,
    funds_raised real,
    cost real,
    issue character(25),
    duartion character(20),
    org_id real
);


ALTER TABLE public.campaigns OWNER TO ubangi;

--
-- Name: campaignsconductedbygng; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.campaignsconductedbygng AS
 SELECT campaigns.camp_name,
    campaigns.campaign_id,
    campaigns.issue
   FROM public.campaigns
  WHERE (campaigns.org_id = ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar)));


ALTER TABLE public.campaignsconductedbygng OWNER TO ubangi;

--
-- Name: camplow; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.camplow AS
 SELECT campaigns.camp_name,
    areas.area_name,
    areas.severity
   FROM (public.campaigns
     JOIN public.areas ON ((campaigns.org_id = areas.org_id)))
  WHERE (areas.severity = 'Low'::bpchar);


ALTER TABLE public.camplow OWNER TO ubangi;

--
-- Name: donor; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.donor (
    firstname character(20) NOT NULL,
    lastname character(20) NOT NULL,
    amountdonated real,
    camp_id real
);


ALTER TABLE public.donor OWNER TO ubangi;

--
-- Name: events; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.events (
    event_name character(20),
    event_id real NOT NULL,
    start_date date,
    end_date date,
    org_id real,
    camp_id real
);


ALTER TABLE public.events OWNER TO ubangi;

--
-- Name: highasthesky; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.highasthesky AS
 SELECT activist_organization.name,
    areas.area_name,
    areas.org_id
   FROM (public.activist_organization
     JOIN public.areas ON ((activist_organization.id = areas.org_id)))
  WHERE (areas.severity = 'High'::bpchar);


ALTER TABLE public.highasthesky OWNER TO ubangi;

--
-- Name: ismember; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.ismember (
    mem_id real NOT NULL,
    org_id real NOT NULL
);


ALTER TABLE public.ismember OWNER TO ubangi;

--
-- Name: members; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.members (
    member_first_name character(20),
    member_last_name character(20),
    member_id real NOT NULL,
    org_id real,
    camp_id real
);


ALTER TABLE public.members OWNER TO ubangi;

--
-- Name: morethan5k; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.morethan5k AS
 SELECT activist_organization.name,
    campaigns.camp_name,
    (campaigns.funds_raised - campaigns.cost) AS total
   FROM (public.campaigns
     JOIN public.activist_organization ON ((activist_organization.id = campaigns.org_id)))
  WHERE ((campaigns.funds_raised - campaigns.cost) > (5000)::double precision)
  ORDER BY (campaigns.funds_raised - campaigns.cost) DESC;


ALTER TABLE public.morethan5k OWNER TO ubangi;

--
-- Name: netincome; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.netincome AS
 SELECT activist_organization.name,
    activist_organization.id,
    ((campaigns.funds_raised - campaigns.cost) - activist_organization.rent) AS netincome
   FROM (public.activist_organization
     JOIN public.campaigns ON ((activist_organization.id = campaigns.org_id)));


ALTER TABLE public.netincome OWNER TO ubangi;

--
-- Name: notgngcampaigns; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.notgngcampaigns AS
 SELECT campaigns.camp_name,
    members.member_first_name,
    members.member_last_name
   FROM (public.campaigns
     JOIN public.members ON ((members.org_id = campaigns.org_id)))
  WHERE (NOT (members.org_id IN ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar))));


ALTER TABLE public.notgngcampaigns OWNER TO ubangi;

--
-- Name: notingng; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.notingng AS
 SELECT DISTINCT employees.first_name,
    employees.last_name,
    employees.employee_id
   FROM (public.employees
     JOIN public.campaigns ON ((employees.org_id = campaigns.org_id)))
  WHERE (NOT (campaigns.org_id IN ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar))));


ALTER TABLE public.notingng OWNER TO ubangi;

--
-- Name: partof; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.partof (
    mem_id real NOT NULL,
    camp_id real NOT NULL
);


ALTER TABLE public.partof OWNER TO ubangi;

--
-- Name: supporters; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.supporters (
    role character(20),
    mem_id real NOT NULL
);


ALTER TABLE public.supporters OWNER TO ubangi;

--
-- Name: volunteers; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.volunteers (
    tier character(20),
    mem_id real NOT NULL
);


ALTER TABLE public.volunteers OWNER TO ubangi;

--
-- Name: tier1volunteers; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.tier1volunteers AS
 SELECT members.member_first_name,
    members.member_last_name,
    members.member_id
   FROM (public.members
     JOIN public.volunteers ON ((members.member_id = volunteers.mem_id)))
  WHERE (members.org_id = ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar)));


ALTER TABLE public.tier1volunteers OWNER TO ubangi;

--
-- Name: totalmembers; Type: VIEW; Schema: public; Owner: ubangi
--

CREATE VIEW public.totalmembers AS
 SELECT count(members.member_first_name) AS count
   FROM public.members
  WHERE (members.org_id = ( SELECT activist_organization.id
           FROM public.activist_organization
          WHERE (activist_organization.name = 'GNG'::bpchar)));


ALTER TABLE public.totalmembers OWNER TO ubangi;

--
-- Name: worksin; Type: TABLE; Schema: public; Owner: ubangi
--

CREATE TABLE public.worksin (
    emp_id real NOT NULL,
    camp_id real NOT NULL
);


ALTER TABLE public.worksin OWNER TO ubangi;

--
-- Data for Name: activist_organization; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.activist_organization (name, id, address, rent) FROM stdin;
GNG    	1011	3800 Finerty Road           	7000
ONC    	1012	1011 Richmond Road          	5000
BWC    	1013	4455 Quadra Street          	9000
ELW    	1014	7127 Blanshard Street       	10000
HSD    	1015	9125 Shelbourne Street      	8000
DTB    	1016	2525 Mckenzie Avenue        	5000
\.


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.areas (area_name, severity, org_id) FROM stdin;
Uplands             	High      	1011
Oak Bay             	Medium    	1016
Langford            	High      	1012
Sooke               	Low       	1011
Cordova Bay         	Medium    	1014
Sidney              	Low       	1013
Saanichton          	High      	1011
Goldstream          	Low       	1015
Colwood             	High      	1012
Duncan              	Medium    	1014
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.campaigns (camp_name, campaign_id, funds_raised, cost, issue, duartion, org_id) FROM stdin;
Trees for Cities        	101	20000	10000	Saving trees for cities  	2 Weeks             	1011
No Farms No Food        	102	15000	5000	Protecting Farmers       	1 Month             	1013
Beat Pollution          	103	20000	10000	Increasing Pollutants    	2 Weeks             	1011
Clean Seas              	104	7000	2000	Dangered Marine Life     	5 Weeks             	1012
Leave Lead              	105	20000	10000	Use of lead paint        	2 Weeks             	1015
Ice Bridge              	106	25000	9000	Melting of Glaciers      	3 Weeks             	1011
Fossil Free             	107	20000	10000	Use fossil fuels         	2 Weeks             	1015
Feel The Heat           	108	15000	2000	Rising Temperatures      	3 Weeks             	1016
Charity Water           	109	20000	10000	Polluted Water           	2 Weeks             	1012
Suffer against Sewage   	110	8000	2000	Bad Sewage System        	5 Weeks             	1014
\.


--
-- Data for Name: donor; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.donor (firstname, lastname, amountdonated, camp_id) FROM stdin;
Lodu                	Chand               	10000	101
Jackie              	Chan                	25000	103
Leo                 	Caprio              	7000	106
Juan                	Mata                	2000	101
Andres              	Iniesta             	50000	106
Romelu              	Lukaku              	30000	103
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.employees (employee_id, first_name, last_name, salary, org_id, camp_id) FROM stdin;
10115	Olly                	Marshall            	25000	1011	103
20115	John                	Snow                	37000	1014	110
30115	Rob                 	Anderson            	29000	1016	108
40115	Josh                	Morrid              	42000	1011	101
50115	Harry               	Kane                	15000	1012	104
60115	Lionel              	Messi               	27000	1015	105
70115	Cristiano           	Ronaldo             	49000	1013	102
80115	Sadio               	Mane                	37000	1011	106
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.events (event_name, event_id, start_date, end_date, org_id, camp_id) FROM stdin;
TreeCon             	11	2019-09-15	2019-09-30	1011	101
Find the tree       	12	2019-07-01	2019-09-25	1011	101
Plant one           	13	2019-05-06	2019-07-08	1011	101
Stop Pol            	14	2019-10-15	2019-10-30	1011	103
Freeze fisrt        	15	2019-12-25	2020-01-30	1011	106
Stop melt           	16	2019-04-02	2019-07-20	1011	106
Red noise           	17	2019-01-15	2019-03-17	1011	103
Water Clean         	18	2019-04-20	2019-07-18	1011	103
\.


--
-- Data for Name: ismember; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.ismember (mem_id, org_id) FROM stdin;
5712	1011
5745	1013
5983	1014
5672	1013
5988	1016
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.members (member_first_name, member_last_name, member_id, org_id, camp_id) FROM stdin;
Eden                	Hazard              	5712	1011	103
Gerard              	Pique               	5745	1013	102
Ivan                	Rakitic             	5983	1014	110
Sergio              	Busquets            	5376	1016	108
Arthur              	Melo                	5672	1013	102
Phillipe            	Coutinho            	5812	1015	105
Luis                	Suarez              	5552	1011	103
Ousmane             	Dembele             	5385	1012	104
Frenkie             	Dejong              	5988	1016	108
Leroy               	Sane                	5294	1015	105
\.


--
-- Data for Name: partof; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.partof (mem_id, camp_id) FROM stdin;
5712	103
5745	102
5983	110
5552	103
5385	104
\.


--
-- Data for Name: supporters; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.supporters (role, mem_id) FROM stdin;
Reporter            	5552
Environmentalist    	5385
Scientist           	5988
Media-Spokesperson  	5294
\.


--
-- Data for Name: volunteers; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.volunteers (tier, mem_id) FROM stdin;
Tier1               	5712
Tier1               	5745
Tier2               	5983
Tier1               	5376
Tier2               	5672
\.


--
-- Data for Name: worksin; Type: TABLE DATA; Schema: public; Owner: ubangi
--

COPY public.worksin (emp_id, camp_id) FROM stdin;
10115	103
40115	101
60115	105
10115	110
70115	102
30115	108
\.


--
-- Name: activist_organization activist_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.activist_organization
    ADD CONSTRAINT activist_organization_pkey PRIMARY KEY (id);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area_name, severity);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (campaign_id);


--
-- Name: donor donor_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT donor_pkey PRIMARY KEY (firstname, lastname);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: ismember ismember_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.ismember
    ADD CONSTRAINT ismember_pkey PRIMARY KEY (org_id, mem_id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (member_id);


--
-- Name: partof partof_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.partof
    ADD CONSTRAINT partof_pkey PRIMARY KEY (camp_id, mem_id);


--
-- Name: supporters supporters_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.supporters
    ADD CONSTRAINT supporters_pkey PRIMARY KEY (mem_id);


--
-- Name: volunteers volunteers_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_pkey PRIMARY KEY (mem_id);


--
-- Name: worksin worksin_pkey; Type: CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.worksin
    ADD CONSTRAINT worksin_pkey PRIMARY KEY (camp_id, emp_id);


--
-- Name: areas areas_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: campaigns campaigns_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: donor donor_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT donor_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: events events_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: events events_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ismember ismember_mem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.ismember
    ADD CONSTRAINT ismember_mem_id_fkey FOREIGN KEY (mem_id) REFERENCES public.members(member_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ismember ismember_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.ismember
    ADD CONSTRAINT ismember_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: members members_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: members members_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.activist_organization(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: partof partof_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.partof
    ADD CONSTRAINT partof_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: partof partof_mem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.partof
    ADD CONSTRAINT partof_mem_id_fkey FOREIGN KEY (mem_id) REFERENCES public.members(member_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: supporters supporters_mem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.supporters
    ADD CONSTRAINT supporters_mem_id_fkey FOREIGN KEY (mem_id) REFERENCES public.members(member_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: volunteers volunteers_mem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_mem_id_fkey FOREIGN KEY (mem_id) REFERENCES public.members(member_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: worksin worksin_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.worksin
    ADD CONSTRAINT worksin_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.campaigns(campaign_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: worksin worksin_emp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ubangi
--

ALTER TABLE ONLY public.worksin
    ADD CONSTRAINT worksin_emp_id_fkey FOREIGN KEY (emp_id) REFERENCES public.employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

