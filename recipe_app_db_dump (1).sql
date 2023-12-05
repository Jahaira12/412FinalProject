--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'WIN1252';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_to_favorites(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.add_to_favorites(userid integer, recid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  BEGIN
    INSERT INTO favorited (user_id, rec_id) VALUES (userID, recID) ON CONFLICT DO NOTHING;
    RETURN TRUE;
  END;
$$;


ALTER FUNCTION public.add_to_favorites(userid integer, recid integer) OWNER TO scott;

--
-- Name: add_to_grocery(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.add_to_grocery(userid integer, ingid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  BEGIN
    INSERT INTO grocery_list (user_id, ing_id) VALUES (userID, ingID) ON CONFLICT DO NOTHING;
    RETURN TRUE;
  END;
$$;


ALTER FUNCTION public.add_to_grocery(userid integer, ingid integer) OWNER TO scott;

--
-- Name: add_user(text, text, text); Type: PROCEDURE; Schema: public; Owner: scott
--

CREATE PROCEDURE public.add_user(IN name text, IN allergens text, IN categories text)
    LANGUAGE sql
    AS $$
  INSERT INTO users VALUES(DEFAULT, name, str_to_array(allergens), str_to_array(categories));
$$;


ALTER PROCEDURE public.add_user(IN name text, IN allergens text, IN categories text) OWNER TO scott;

--
-- Name: decrement_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.decrement_stock(userid integer, ingid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF EXISTS (SELECT FROM pantry WHERE user_id = userID and ing_id = ingID and stock_level = 'full') THEN
      UPDATE pantry SET stock_level = 'low' WHERE user_id = userID and ing_id = ingID;
      RETURN 'low';
    ELSE
      UPDATE pantry SET stock_level = 'out' WHERE user_id = userID and ing_id = ingID;
      RETURN 'out';
    END IF;
  END;
$$;


ALTER FUNCTION public.decrement_stock(userid integer, ingid integer) OWNER TO scott;

--
-- Name: get_allergens_to_avoid(integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.get_allergens_to_avoid(userid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    allergens text;
  BEGIN
    allergens = array_to_string((SELECT avoid_allergens FROM users WHERE user_id = userID), ', ');
    RETURN allergens;
  END;
$$;


ALTER FUNCTION public.get_allergens_to_avoid(userid integer) OWNER TO scott;

--
-- Name: get_categories_to_avoid(integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.get_categories_to_avoid(userid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    categories text;
  BEGIN
    categories = array_to_string((SELECT avoid_categories FROM users WHERE user_id = userID), ', ');
    RETURN categories;
  END;
$$;


ALTER FUNCTION public.get_categories_to_avoid(userid integer) OWNER TO scott;

--
-- Name: get_userid(text); Type: FUNCTION; Schema: public; Owner: ssnar
--

CREATE FUNCTION public.get_userid(username text) RETURNS integer
    LANGUAGE plpgsql
    AS $$  DECLARE    id integer;  BEGIN    id = (SELECT min(user_id) FROM USERS WHERE name = username);RETURN id;  END;$$;


ALTER FUNCTION public.get_userid(username text) OWNER TO ssnar;

--
-- Name: increment_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.increment_stock(userid integer, ingid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    UPDATE pantry SET stock_level = 'full' WHERE user_id = userID and ing_id = ingID;
    RETURN 'full';
  END;
$$;


ALTER FUNCTION public.increment_stock(userid integer, ingid integer) OWNER TO scott;

--
-- Name: remove_from_favorites(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.remove_from_favorites(userid integer, recid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  BEGIN
    DELETE FROM favorited WHERE user_id = userID and rec_id = recid;
    RETURN TRUE;
  END;
$$;


ALTER FUNCTION public.remove_from_favorites(userid integer, recid integer) OWNER TO scott;

--
-- Name: remove_from_grocery(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.remove_from_grocery(userid integer, ingid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  BEGIN
    DELETE FROM grocery_list WHERE user_id = userID and ing_id = ingid;
    RETURN TRUE;
  END;
$$;


ALTER FUNCTION public.remove_from_grocery(userid integer, ingid integer) OWNER TO scott;

--
-- Name: str_to_array(text, text); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.str_to_array(t1 text, dl text DEFAULT ','::text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  arr text[];
  elem text;
BEGIN
  IF t1 = '' THEN
    SELECT NULL INTO arr;
  ELSE
    SELECT string_to_array(btrim(t1, '{}[]() '), dl) INTO arr;
  END IF;
  FOR i IN 1 .. array_upper(arr, 1)
  LOOP
    arr[i] = btrim(arr[i], ' ');
  END LOOP;
  RETURN arr;
END;
$$;


ALTER FUNCTION public.str_to_array(t1 text, dl text) OWNER TO scott;

--
-- Name: test_add(integer, integer); Type: FUNCTION; Schema: public; Owner: scott
--

CREATE FUNCTION public.test_add(num1 integer, num2 integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE sum int; BEGIN
  IF num1 = 0
  THEN SELECT NULL INTO sum;
  ELSE
  SELECT( num1 + num2) INTO sum;
  END IF; RETURN sum;
END;
$$;


ALTER FUNCTION public.test_add(num1 integer, num2 integer) OWNER TO scott;

--
-- Name: update_allergens_to_avoid(integer, text); Type: FUNCTION; Schema: public; Owner: ssnar
--

CREATE FUNCTION public.update_allergens_to_avoid(userid integer, allergens text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$  BEGIN    INSERT INTO users VALUES (userID, '', str_to_array(allergens), NULL) ON CONFLICT (user_id) DO UPDATE SET avoid_allergens = str_to_array(allergens);    RETURN TRUE;  END;$$;


ALTER FUNCTION public.update_allergens_to_avoid(userid integer, allergens text) OWNER TO ssnar;

--
-- Name: update_categories_to_avoid(integer, text); Type: FUNCTION; Schema: public; Owner: ssnar
--

CREATE FUNCTION public.update_categories_to_avoid(userid integer, categories text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$  BEGIN    INSERT INTO users VALUES (userID, '', NULL, str_to_array(categories)) ON CONFLICT (user_id) DO UPDATE SET avoid_categories = str_to_array(categories);    RETURN TRUE;  END;$$;


ALTER FUNCTION public.update_categories_to_avoid(userid integer, categories text) OWNER TO ssnar;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: allergen; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.allergen (
    ing_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.allergen OWNER TO scott;

--
-- Name: category; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.category (
    ing_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO scott;

--
-- Name: favorited; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.favorited (
    rec_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.favorited OWNER TO scott;

--
-- Name: grocery_list; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.grocery_list (
    user_id integer NOT NULL,
    ing_id integer NOT NULL
);


ALTER TABLE public.grocery_list OWNER TO scott;

--
-- Name: ingredient; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.ingredient (
    ing_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.ingredient OWNER TO scott;

--
-- Name: ingredient_ing_id_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.ingredient_ing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredient_ing_id_seq OWNER TO scott;

--
-- Name: ingredient_ing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.ingredient_ing_id_seq OWNED BY public.ingredient.ing_id;


--
-- Name: is_made_with; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.is_made_with (
    rec_id integer NOT NULL,
    ing_id integer NOT NULL,
    qty numeric(8,5),
    unit_of_measure character varying(50)
);


ALTER TABLE public.is_made_with OWNER TO scott;

--
-- Name: pantry; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.pantry (
    user_id integer NOT NULL,
    ing_id integer NOT NULL,
    stock_level text,
    CONSTRAINT pantry_stock_level_check CHECK ((stock_level = ANY (ARRAY['out'::text, 'low'::text, 'full'::text])))
);


ALTER TABLE public.pantry OWNER TO scott;

--
-- Name: rated; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.rated (
    rec_id integer NOT NULL,
    user_id integer NOT NULL,
    rating integer
);


ALTER TABLE public.rated OWNER TO scott;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.rating (
    rec_id integer NOT NULL,
    avg_rating double precision,
    num_ratings integer
);


ALTER TABLE public.rating OWNER TO scott;

--
-- Name: recipe; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.recipe (
    rec_id integer NOT NULL,
    servings integer,
    name character varying(50) NOT NULL,
    instructions character varying(65000),
    style text[]
);


ALTER TABLE public.recipe OWNER TO scott;

--
-- Name: recipe_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.recipe_rec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_rec_id_seq OWNER TO scott;

--
-- Name: recipe_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.recipe_rec_id_seq OWNED BY public.recipe.rec_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name character varying(50) NOT NULL,
    avoid_allergens text[],
    avoid_categories text[]
);


ALTER TABLE public.users OWNER TO scott;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO scott;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: ingredient ing_id; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN ing_id SET DEFAULT nextval('public.ingredient_ing_id_seq'::regclass);


--
-- Name: recipe rec_id; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.recipe ALTER COLUMN rec_id SET DEFAULT nextval('public.recipe_rec_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: allergen; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.allergen (ing_id, name) FROM stdin;
28	Lactose
10	Eggs
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.category (ing_id, name) FROM stdin;
7	Dairy
28	Dairy
6	Chicken
7	Cheese
14	Dairy
14	Cheese
6	Meat
25	Non-Vegan
10	Eggs
\.


--
-- Data for Name: favorited; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.favorited (rec_id, user_id) FROM stdin;
2	1
\.


--
-- Data for Name: grocery_list; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.grocery_list (user_id, ing_id) FROM stdin;
1	15
\.


--
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.ingredient (ing_id, name) FROM stdin;
1	tomato
2	garlic
3	olive oil
4	chile
5	salt
6	chicken
7	parmesan
8	pasta
9	broccoli
10	eggs
11	basil
12	panko bread crumbs
13	marinara sauce
14	mozzarella
15	chicken breast
16	black pepper
17	flour
18	Garlic Clove(s), Minced
19	Butter
20	Crushed Red Pepper Flakes
21	Carrot(s), peeled and chopped
22	Large Onion(s), chopped
23	Dried Basil
24	Whole Peeled Tomatoes
25	Chicken Stock
26	Tomato Paste
27	Sugar
28	Heavy Whipping Cream
\.


--
-- Data for Name: is_made_with; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.is_made_with (rec_id, ing_id, qty, unit_of_measure) FROM stdin;
1	15	2.00000	lbs
1	14	1.00000	cup
1	7	1.00000	cup
1	13	2.00000	cup
1	3	1.00000	cup
1	10	3.00000	
1	17	0.50000	cup
1	12	2.00000	cup
2	3	3.00000	tablespoons
2	19	3.00000	tablespoons
2	20	0.50000	teaspoons
2	21	3.00000	
2	22	1.00000	
2	23	2.00000	teaspoons
2	24	3.00000	28 oz cans
2	25	1.00000	32 oz container
2	26	2.00000	tablespoons
2	27	3.00000	teaspoons
2	5	1.00000	teaspoon
2	16	0.50000	teaspoon
2	28	1.00000	cup
\.


--
-- Data for Name: pantry; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.pantry (user_id, ing_id, stock_level) FROM stdin;
1	3	full
1	19	full
1	20	full
1	21	low
1	22	full
1	23	full
1	24	full
1	25	low
1	26	full
1	27	full
1	5	full
1	16	full
1	28	full
\.


--
-- Data for Name: rated; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.rated (rec_id, user_id, rating) FROM stdin;
2	1	8
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.rating (rec_id, avg_rating, num_ratings) FROM stdin;
1	0	0
2	7.5	2
\.


--
-- Data for Name: recipe; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.recipe (rec_id, servings, name, instructions, style) FROM stdin;
1	4	Chicken Parmesan	    Step 1\n    Heat oven to 400 degrees. Place cutlets between two pieces of parchment or plastic wrap. Using a kitchen mallet or rolling pin, pound meat to even ¼-inch-thick slices.\n    \n\tStep 2\n    Place flour, eggs and panko into three wide, shallow bowls. Season meat generously with salt and pepper. Dip a piece in flour, then eggs, then coat with panko. Repeat until all the meat is coated.\n    \n\tStep 3\n    Fill a large skillet with ½-inch oil. Place over medium-high heat. When oil is hot, fry cutlets in batches, turning halfway through, until golden brown. Transfer to a paper towel-lined plate.\n    \n\tStep 4\n    Spoon a thin layer of sauce over the bottom of a 9-by-13-inch baking pan. Sprinkle one-third of the Parmesan over sauce. Place half of the cutlets over the Parmesan and top with half the mozzarella pieces. Top with half the remaining sauce, sprinkle with another third of the Parmesan, and repeat layering, ending with a final layer of sauce and Parmesan.\n    \n\tStep 5\n    Transfer pan to oven and bake until cheese is golden and casserole is bubbling, about 40 minutes. Let cool a few minutes before serving.	{Italian}
2	4	Tomato Soup	    1. In a 6-quart stockpot or Dutch oven, heat oil, butter and pepper flakes over medium heat until butter is melted. Add carrots and onion; cook, uncovered, over medium heat, stirring frequently, until vegetables are softened, 8-10 minutes. Add garlic and basil; cook and stir 1 minute longer. Stir in tomatoes, chicken stock, tomato paste, sugar, salt and pepper; mix well. Bring to a boil. Reduce heat; simmer, uncovered, to let flavors blend, 20-25 minutes.\n    2. Remove pan from heat. Using a blender, puree soup in batches until smooth. If desired, slowly stir in heavy cream, stirring continuously to incorporate; return to stove to heat through. Top servings with fresh basil and Parmesan cheese if desired.	{Soup}
3	2	Grilled Cheese	1. Toast the bread\n2. Melt the cheese\n3. Enjoy	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.users (user_id, name, avoid_allergens, avoid_categories) FROM stdin;
2	John Smith	{shellfish,peanuts}	\N
3	John Smith2	{"John Smith2"}	{}
4	John Smith3	{}	{}
5	John Smith4	{apples," avocados"}	\N
6	John Smith5	{apples,avocados}	\N
7	John Smith5	\N	\N
8	1	{Avocado,Shellfish,Peanuts}	\N
9	1	{Avocado,Shellfish,Peanuts}	\N
10	1	\N	{Vegan}
11	1	\N	{Vegan}
12	1	{Avocado,Shellfish,Peanuts}	\N
13	1	{Avocado,Shellfish,Peanuts}	\N
14	1	{Avocado,Shellfish,Peanuts}	\N
15	1	{Avocado,Shellfish,Peanuts}	\N
17		{Avocado,Shellfish,Peanuts}	\N
1	Tom Selleck	{Avocado,Shellfish}	{Vegan}
\.


--
-- Name: ingredient_ing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.ingredient_ing_id_seq', 28, true);


--
-- Name: recipe_rec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.recipe_rec_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.users_user_id_seq', 17, true);


--
-- Name: allergen allergen_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.allergen
    ADD CONSTRAINT allergen_pkey PRIMARY KEY (ing_id, name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (ing_id, name);


--
-- Name: favorited favorited_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.favorited
    ADD CONSTRAINT favorited_pkey PRIMARY KEY (rec_id, user_id);


--
-- Name: grocery_list grocery_list_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.grocery_list
    ADD CONSTRAINT grocery_list_pkey PRIMARY KEY (user_id, ing_id);


--
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (ing_id);


--
-- Name: is_made_with is_made_with_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.is_made_with
    ADD CONSTRAINT is_made_with_pkey PRIMARY KEY (rec_id, ing_id);


--
-- Name: pantry pantry_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.pantry
    ADD CONSTRAINT pantry_pkey PRIMARY KEY (user_id, ing_id);


--
-- Name: rated rated_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.rated
    ADD CONSTRAINT rated_pkey PRIMARY KEY (rec_id, user_id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (rec_id);


--
-- Name: recipe recipe_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (rec_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: allergen allergen_ing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.allergen
    ADD CONSTRAINT allergen_ing_id_fkey FOREIGN KEY (ing_id) REFERENCES public.ingredient(ing_id);


--
-- Name: category category_ing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_ing_id_fkey FOREIGN KEY (ing_id) REFERENCES public.ingredient(ing_id);


--
-- Name: favorited favorited_rec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.favorited
    ADD CONSTRAINT favorited_rec_id_fkey FOREIGN KEY (rec_id) REFERENCES public.recipe(rec_id);


--
-- Name: favorited favorited_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.favorited
    ADD CONSTRAINT favorited_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: grocery_list grocery_list_ing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.grocery_list
    ADD CONSTRAINT grocery_list_ing_id_fkey FOREIGN KEY (ing_id) REFERENCES public.ingredient(ing_id);


--
-- Name: grocery_list grocery_list_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.grocery_list
    ADD CONSTRAINT grocery_list_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: is_made_with is_made_with_ing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.is_made_with
    ADD CONSTRAINT is_made_with_ing_id_fkey FOREIGN KEY (ing_id) REFERENCES public.ingredient(ing_id);


--
-- Name: is_made_with is_made_with_rec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.is_made_with
    ADD CONSTRAINT is_made_with_rec_id_fkey FOREIGN KEY (rec_id) REFERENCES public.recipe(rec_id);


--
-- Name: pantry pantry_ing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.pantry
    ADD CONSTRAINT pantry_ing_id_fkey FOREIGN KEY (ing_id) REFERENCES public.ingredient(ing_id);


--
-- Name: pantry pantry_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.pantry
    ADD CONSTRAINT pantry_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: rated rated_rec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.rated
    ADD CONSTRAINT rated_rec_id_fkey FOREIGN KEY (rec_id) REFERENCES public.recipe(rec_id);


--
-- Name: rated rated_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.rated
    ADD CONSTRAINT rated_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: rating rating_rec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_rec_id_fkey FOREIGN KEY (rec_id) REFERENCES public.recipe(rec_id);


--
-- Name: TABLE allergen; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.allergen TO app_access;


--
-- Name: TABLE category; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.category TO app_access;


--
-- Name: TABLE favorited; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.favorited TO app_access;


--
-- Name: TABLE grocery_list; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.grocery_list TO app_access;


--
-- Name: TABLE ingredient; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.ingredient TO app_access;


--
-- Name: TABLE is_made_with; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.is_made_with TO app_access;


--
-- Name: TABLE pantry; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.pantry TO app_access;


--
-- Name: TABLE rated; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.rated TO app_access;


--
-- Name: TABLE rating; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.rating TO app_access;


--
-- Name: TABLE recipe; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.recipe TO app_access;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: scott
--

GRANT ALL ON TABLE public.users TO app_access;


--
-- Name: SEQUENCE users_user_id_seq; Type: ACL; Schema: public; Owner: scott
--

GRANT SELECT,USAGE ON SEQUENCE public.users_user_id_seq TO app_access;


--
-- PostgreSQL database dump complete
--

