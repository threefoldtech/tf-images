create database peertube_prod;
create user peertube password 'peertube';
grant all privileges on database peertube_prod to peertube;
\c peertube_prod
CREATE EXTENSION pg_trgm;
CREATE EXTENSION unaccent;
