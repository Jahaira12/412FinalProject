--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'WIN1252';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE app_access;
ALTER ROLE app_access WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:u/gwQe+IIOi7xxDjZKP6EQ==$9SjwJm4WepPO5+i1oj58rf43GUNCtdIaRTeNYqqjJ/Q=:i8HD4OlHUmCwoQJU5pESWJzgPbJ8ekVIl173AyXaplo=';
CREATE ROLE appaccess;
ALTER ROLE appaccess WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:KdKi5Ix2XnNMC3yVfyzApQ==$rdpHS0jCVAss3hFJaBno1PvuRGvwHeqzZr6skkMMeas=:JQt5ktm40/RDHVe1A6BUtnGo9CLVg+OckRWmclhKDJI=';
CREATE ROLE scott;
ALTER ROLE scott WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE ssnar;
ALTER ROLE ssnar WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--






--
-- PostgreSQL database cluster dump complete
--

