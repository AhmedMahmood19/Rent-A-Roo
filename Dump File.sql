--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

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
-- Name: favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favourites (
    guest_id integer NOT NULL,
    listing_id integer NOT NULL
);


--
-- Name: listing_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listing_images (
    listing_id integer NOT NULL,
    image_path character varying NOT NULL
);


--
-- Name: listings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listings (
    listing_id integer NOT NULL,
    host_id integer,
    title character varying NOT NULL,
    description character varying NOT NULL,
    state character varying NOT NULL,
    city character varying NOT NULL,
    address character varying NOT NULL,
    is_apartment boolean NOT NULL,
    apartment_no character varying,
    gps_location character varying,
    is_shared boolean NOT NULL,
    accommodates integer NOT NULL,
    bathrooms integer NOT NULL,
    bedrooms integer NOT NULL,
    nightly_price integer NOT NULL,
    min_nights integer NOT NULL,
    max_nights integer NOT NULL,
    wifi boolean NOT NULL,
    kitchen boolean NOT NULL,
    washing_machine boolean NOT NULL,
    air_conditioning boolean NOT NULL,
    tv boolean NOT NULL,
    hair_dryer boolean NOT NULL,
    iron boolean NOT NULL,
    pool boolean NOT NULL,
    gym boolean NOT NULL,
    smoking_allowed boolean NOT NULL,
    total_ratings integer,
    rating integer,
    view_count integer,
    is_listed boolean
);


--
-- Name: listings_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.listings_listing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: listings_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.listings_listing_id_seq OWNED BY public.listings.listing_id;


--
-- Name: promoted_listings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promoted_listings (
    listing_id integer NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL
);


--
-- Name: questions_and_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions_and_answers (
    question_id integer NOT NULL,
    listing_id integer,
    guest_id integer,
    question character varying NOT NULL,
    answer character varying,
    created_time timestamp with time zone DEFAULT now()
);


--
-- Name: questions_and_answers_question_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_and_answers_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_and_answers_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_and_answers_question_id_seq OWNED BY public.questions_and_answers.question_id;


--
-- Name: ratings_and_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ratings_and_reviews (
    review_id integer NOT NULL,
    listing_id integer,
    guest_id integer,
    rating integer NOT NULL,
    review character varying,
    created_time timestamp with time zone DEFAULT now()
);


--
-- Name: ratings_and_reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ratings_and_reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_and_reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ratings_and_reviews_review_id_seq OWNED BY public.ratings_and_reviews.review_id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservations (
    reservation_id integer NOT NULL,
    listing_id integer,
    guest_id integer,
    checkin_date timestamp with time zone NOT NULL,
    checkout_date timestamp with time zone NOT NULL,
    created_time timestamp with time zone DEFAULT now(),
    amount_due integer NOT NULL,
    status character varying
);


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservations_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reservations_reservation_id_seq OWNED BY public.reservations.reservation_id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    listing_id integer,
    guest_id integer,
    checkin_date timestamp with time zone NOT NULL,
    checkout_date timestamp with time zone NOT NULL,
    created_time timestamp with time zone DEFAULT now(),
    amount_paid integer NOT NULL,
    has_guest_rated boolean,
    has_host_rated boolean
);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone_no character varying(11) NOT NULL,
    image_path character varying,
    avg_host_rating integer,
    avg_guest_rating integer,
    total_host_rating integer,
    total_guest_rating integer,
    about_me character varying
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: listings listing_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings ALTER COLUMN listing_id SET DEFAULT nextval('public.listings_listing_id_seq'::regclass);


--
-- Name: questions_and_answers question_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_and_answers ALTER COLUMN question_id SET DEFAULT nextval('public.questions_and_answers_question_id_seq'::regclass);


--
-- Name: ratings_and_reviews review_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings_and_reviews ALTER COLUMN review_id SET DEFAULT nextval('public.ratings_and_reviews_review_id_seq'::regclass);


--
-- Name: reservations reservation_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservations_reservation_id_seq'::regclass);


--
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: favourites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favourites (guest_id, listing_id) FROM stdin;
5	4
5	2
5	3
4	5
4	6
\.


--
-- Data for Name: listing_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.listing_images (listing_id, image_path) FROM stdin;
1	/static/images/4388ffc71.webp
1	/static/images/567827721.webp
1	/static/images/93adb9c61.webp
2	/static/images/bc407f779221.jpg
2	/static/images/bc407f779222.webp
2	/static/images/bc407f779223.webp
3	/static/images/8a1891893.webp
3	/static/images/fe8094223.webp
3	/static/images/b246b24c3.webp
3	/static/images/399eaa423.webp
4	/static/images/80faf7244.webp
4	/static/images/d6c8faad4.webp
4	/static/images/bd5eee234.webp
4	/static/images/e15703164.webp
5	/static/images/54fea97a5.webp
5	/static/images/64c5fe885.webp
5	/static/images/81dc754f5.webp
5	/static/images/ac5735895.webp
6	/static/images/3aec06b56.jpg
6	/static/images/4416a2566.webp
6	/static/images/704186ce6.jpg
6	/static/images/e19050156.jpeg
7	/static/images/6c6151f17.jpeg
7	/static/images/6fe550c87.jpeg
8	/static/images/8c8ca6ff8.jpeg
8	/static/images/4cdeb41a8.jpeg
9	/static/images/0b4e21a09.jpeg
9	/static/images/727dae5a9.jpeg
\.


--
-- Data for Name: listings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.listings (listing_id, host_id, title, description, state, city, address, is_apartment, apartment_no, gps_location, is_shared, accommodates, bathrooms, bedrooms, nightly_price, min_nights, max_nights, wifi, kitchen, washing_machine, air_conditioning, tv, hair_dryer, iron, pool, gym, smoking_allowed, total_ratings, rating, view_count, is_listed) FROM stdin;
1	2	Beach house with a great view	You can view the beautiful sea from the terrace of the house, all rooms have brown marble flooring with wide windows that open up directly to the sea	Sindh	Karachi	Plot D-28, 38th St, Phase 6 DHA	f	\N	\N	f	5	3	4	7500	2	15	t	t	t	t	t	f	f	f	f	f	0	0	0	t
2	1	Luxurious apartment in the middle of the city	The apartment has a single master bedroom but it is big enough to fit around 4 people, but it only has a single bed	Punjab	Lahore	Apartment 22E, Sector B Apartments, Askari 11	t	22E	\N	f	4	1	1	2400	5	10	t	t	f	f	f	f	f	f	f	t	0	0	0	t
3	4	Regal Urban Minimalism	Gaze out across the city from high up in this 16th-floor retreat. The expansive residence features an open-plan layout, floor-to-ceiling windows, soothing greys, chic furnishings and decor, and breathtaking panoramic vistas.	Punjab	Islamabad	Apt 5A, legion towers, Sector G6, Islamabad	t	16K	\N	f	3	1	1	25000	3	7	t	t	t	t	t	t	t	f	f	f	3	3	1000	t
4	4	Unique woody feel and panoramic views of the mountains	The spacious terrace has a sitting arrangement for 4 and has the most gorgeous views you can soak in from all of the region. We can arrange for a bonfire or barbecue in the terrace as well.	Punjab	Murree	G-14, Kuldana Road, Murree, Punjab	f	\N	\N	f	6	2	2	15000	2	5	t	t	f	t	f	f	f	f	f	t	2	3	790	t
5	7	Modern living in the heart of Karachi	A modern 2 Bedroom Apartment on the 9th floor with amazing view in the heart of Karachi. It comes with all amenities, central air conditioning, 24/7 generator/power backup, security, lift with free underground parking. The apartments have a gym and a pool too	Sindh	Karachi	Apartment H174, Phase 3, Navy Housing Scheme Karsaz, Karachi	t	H174	\N	f	4	2	2	12000	6	12	t	t	t	t	t	t	t	t	t	t	1	5	110	t
6	7	Magnificent apartments near the beautiful Arabian Sea	Inside layout combines modern living confluenced to our cultural ethos. A magnificent clubhouse offering a swimming pool, card room, snooker room, gym, community hall and other indoor games.	Sindh	Karachi	Apartment P12, Creek Vista Apartments, Karachi	t	P12	\N	f	4	2	2	17000	2	10	t	t	f	t	t	f	f	t	t	t	0	0	80	t
7	4	Magnificent Villas 	Sea, sand, and sun merge in prism-like perfection at this modern villa	Sindh	Karachi	Apartment P12, Creek Vista Apartments, Karachi	f	\N	\N	f	4	2	2	17000	2	10	t	t	f	t	t	f	f	t	t	t	0	0	80	t
8	4	Magnificent Apartment 	Sea, sand, and sun merge in prism-like perfection at this modern apartment	Sindh	Karachi	Apartment P12, Creek Vista Apartments, Karachi	t	C62	\N	f	4	2	2	17000	2	10	t	t	f	t	t	f	f	t	t	t	0	0	80	t
9	4	Not Magnificent But Great Apartment 	Sea, sand, and sun merge in prism-like not perfect at this old apartment	Sindh	Lahore	Apartment P12, Creek Vista Apartments, Karachi	t	C26	\N	f	4	2	2	17000	2	10	t	t	f	t	t	f	f	t	t	t	0	0	80	t
\.


--
-- Data for Name: promoted_listings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promoted_listings (listing_id, start_time, end_time) FROM stdin;
2	2022-12-07 19:25:07.983189+05	2022-12-09 19:25:07.983189+05
7	2022-12-07 19:25:07.983189+05	2022-12-09 19:25:07.983189+05
8	2022-12-07 19:25:07.983189+05	2022-12-09 19:25:07.983189+05
3	2022-12-05 19:30:07.983189+05	2022-12-07 19:30:07.983189+05
4	2022-12-05 19:30:07.983189+05	2022-12-07 19:30:07.983189+05
\.


--
-- Data for Name: questions_and_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions_and_answers (question_id, listing_id, guest_id, question, answer, created_time) FROM stdin;
1	3	5	Are there any good malls nearby?	Yes, legion mall is a 5 min walk away and has all the international brands you could think of.	2022-12-07 19:25:08.018147+05
2	3	5	Do these apartments offer free parking?	\N	2022-12-07 19:25:08.018147+05
3	3	\N	Can you lower the price a bit? This is too expensive!!!	\N	2022-12-07 19:25:08.018147+05
4	3	\N	Are pets allowed?	Ofcourse, I look forward to meeting them too when you check in :)	2022-12-07 19:25:08.018147+05
5	4	1	How cold does it get there during december?	\N	2022-12-07 19:25:08.018147+05
6	4	7	Is there public transport available in this area?	Yes there is a public bus that has a stop right outside the street from here	2022-12-07 19:25:08.018147+05
\.


--
-- Data for Name: ratings_and_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ratings_and_reviews (review_id, listing_id, guest_id, rating, review, created_time) FROM stdin;
1	5	4	5	This was a beautiful place to stay at and I will 100 percent be visiting again!	2022-12-07 19:25:08.029054+05
2	4	7	4	\N	2022-12-07 19:25:08.029054+05
3	4	6	2	This was too expensive and not worth it	2022-12-07 19:25:08.029054+05
4	3	2	5	The view was amazing and the host was very helpful with any problems I had	2022-12-07 19:25:08.029054+05
5	3	5	5	Wonderful experience, I could never buy this place but thanks to rent-a-roo I can atleast rent it lol	2022-12-07 19:25:08.029054+05
6	3	\N	1	I had the worst experience, the place was fine but the neigbourhood is so dangerous I got robbed at gunpoint coming home at night	2022-12-07 19:25:08.029054+05
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservations (reservation_id, listing_id, guest_id, checkin_date, checkout_date, created_time, amount_due, status) FROM stdin;
1	4	5	2022-11-20 14:00:00+05	2022-12-01 14:00:00+05	2022-12-06 19:33:07.983189+05	82500	Pending
2	3	5	2022-12-06 14:00:00+05	2022-12-13 14:00:00+05	2022-12-07 19:25:07.995439+05	52500	Pending
3	7	5	2022-12-06 14:00:00+05	2022-12-13 14:00:00+05	2022-12-07 19:25:07.995439+05	52500	Pending
4	8	3	2022-12-06 14:00:00+05	2022-12-13 14:00:00+05	2022-12-07 19:25:07.995439+05	52500	Pending
5	9	6	2022-12-06 14:00:00+05	2022-12-13 14:00:00+05	2022-12-07 19:25:07.995439+05	52500	Pending
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (transaction_id, listing_id, guest_id, checkin_date, checkout_date, created_time, amount_paid, has_guest_rated, has_host_rated) FROM stdin;
1	4	5	2022-12-04 19:28:07.983189+05	2022-12-07 19:28:07.983189+05	2022-12-07 19:25:08.006915+05	82500	\N	\N
2	3	5	2022-12-14 14:00:00+05	2022-12-21 14:00:00+05	2022-12-07 19:25:08.006915+05	52500	\N	\N
3	5	4	2022-11-08 14:00:00+05	2022-11-19 14:00:00+05	2022-12-07 19:25:08.006915+05	82500	t	t
4	4	7	2022-09-14 14:00:00+05	2022-09-17 14:00:00+05	2022-12-07 19:25:08.006915+05	45000	t	t
5	4	6	2022-04-10 14:00:00+05	2022-04-14 14:00:00+05	2022-12-07 19:25:08.006915+05	60000	t	t
6	3	2	2022-10-11 14:00:00+05	2022-10-14 14:00:00+05	2022-12-07 19:25:08.006915+05	75000	t	t
7	3	5	2022-09-03 14:00:00+05	2022-09-07 14:00:00+05	2022-12-07 19:25:08.006915+05	100000	t	t
8	3	\N	2022-09-10 14:00:00+05	2022-09-13 14:00:00+05	2022-12-07 19:25:08.006915+05	75000	t	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, email, password, first_name, last_name, phone_no, image_path, avg_host_rating, avg_guest_rating, total_host_rating, total_guest_rating, about_me) FROM stdin;
1	pam@gmail.com	pamb	Pam	Beesly	03348652936	/static/images/ae9f7e4b1.jpg	0	0	0	0	I love to keep my home nice and tidy, so you never have to worry when staying at my house.
2	jim@gmail.com	jim123	Jim	Halpert	03348652936	/static/images/29eb25b52.webp	0	3	0	1	Me and my wife Pam love having people stay at our house and explore our city, I strive to make your stay comfortable and hope you have a good time.
3	abc@gmail.com	abc	Michael	Scott	03231932775	/static/images/e4f035533.png	0	0	0	0	I am new to all this tech stuff and keep forgetting my password.
4	abdullah@gmail.com	abd	Abdullah	Riaz	03132334645	/static/images/fb0cfdbb4.webp	4	5	5	1	I am a photographer who mostly lives abroad and keep all my houses maintained to a high standard.
5	hina@gmail.com	hin	Hina	Qureshi	03168333542	/static/images/226d7de75.jpg	0	5	0	1	An ecopreneur, marketing professional, and a travel junkie, I love reading and sleeping when I am not going places. I love traveling on Rent-A-Roo
6	ali@gmail.com	aliak	Ali	Akbar	03257448423	/static/images/146926d96.webp	0	4	0	1	I am Ali, a Software Professional, deeply interested in Art, Literature, and Culture. I have been travelling for the last 10 years and been using Rent-A-Roo and it continues to be a great experience. I have visited over 45 countries
7	adeel@gmail.com	ade	Adeel	Ansari	03334467893	/static/images/07ce1fb57.webp	5	5	1	1	Entrepreneur, Designer and a loving father, I am a British/Pakistani living in Karachi since 2008 I have been hosting since 2017 with my wife and absolutely love it. Looking forward to hosting you next.
\.


--
-- Name: listings_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.listings_listing_id_seq', 9, true);


--
-- Name: questions_and_answers_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_and_answers_question_id_seq', 6, true);


--
-- Name: ratings_and_reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ratings_and_reviews_review_id_seq', 6, true);


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reservations_reservation_id_seq', 5, true);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 8, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 7, true);


--
-- Name: favourites favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (guest_id, listing_id);


--
-- Name: listing_images listing_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing_images
    ADD CONSTRAINT listing_images_pkey PRIMARY KEY (listing_id, image_path);


--
-- Name: listings listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (listing_id);


--
-- Name: promoted_listings promoted_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promoted_listings
    ADD CONSTRAINT promoted_listings_pkey PRIMARY KEY (listing_id);


--
-- Name: questions_and_answers questions_and_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_and_answers
    ADD CONSTRAINT questions_and_answers_pkey PRIMARY KEY (question_id);


--
-- Name: ratings_and_reviews ratings_and_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings_and_reviews
    ADD CONSTRAINT ratings_and_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: ix_listings_listing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_listings_listing_id ON public.listings USING btree (listing_id);


--
-- Name: ix_promoted_listings_listing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_promoted_listings_listing_id ON public.promoted_listings USING btree (listing_id);


--
-- Name: ix_questions_and_answers_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_questions_and_answers_question_id ON public.questions_and_answers USING btree (question_id);


--
-- Name: ix_ratings_and_reviews_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ratings_and_reviews_review_id ON public.ratings_and_reviews USING btree (review_id);


--
-- Name: ix_reservations_reservation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reservations_reservation_id ON public.reservations USING btree (reservation_id);


--
-- Name: ix_transactions_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_transactions_transaction_id ON public.transactions USING btree (transaction_id);


--
-- Name: ix_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_user_id ON public.users USING btree (user_id);


--
-- Name: favourites favourites_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: favourites favourites_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: listing_images listing_images_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing_images
    ADD CONSTRAINT listing_images_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: listings listings_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: promoted_listings promoted_listings_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promoted_listings
    ADD CONSTRAINT promoted_listings_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: questions_and_answers questions_and_answers_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_and_answers
    ADD CONSTRAINT questions_and_answers_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: questions_and_answers questions_and_answers_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_and_answers
    ADD CONSTRAINT questions_and_answers_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: ratings_and_reviews ratings_and_reviews_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings_and_reviews
    ADD CONSTRAINT ratings_and_reviews_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: ratings_and_reviews ratings_and_reviews_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings_and_reviews
    ADD CONSTRAINT ratings_and_reviews_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: reservations reservations_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: reservations reservations_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- Name: transactions transactions_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: transactions transactions_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id);


--
-- PostgreSQL database dump complete
--

