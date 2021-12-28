

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


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.doctors DISABLE TRIGGER ALL;



ALTER TABLE public.doctors ENABLE TRIGGER ALL;


ALTER TABLE public.patients DISABLE TRIGGER ALL;

INSERT INTO public.patients (id, insurance_type, preferred_contact_method, profile_id, national_id, birthday) VALUES ('3628328f-8630-47d9-8b06-6f8e51ddd6b9', 'galeno', 'phone', '3b42e8f3-835c-4a28-b378-d8ac2692a031', '92525840', '1858-11-17');


ALTER TABLE public.patients ENABLE TRIGGER ALL;


ALTER TABLE public.profiles DISABLE TRIGGER ALL;

INSERT INTO public.profiles (id, last_name, email, user_role, user_name, user_password, first_name, phone, cell_phone) VALUES ('3b42e8f3-835c-4a28-b378-d8ac2692a031', 'Tirao', 'marcos.tirao@icloud.com', 'admin', 'mtirao', '3186AppL', 'Marcos', '', '');


ALTER TABLE public.profiles ENABLE TRIGGER ALL;


