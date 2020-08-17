#! /bin/bash
set -ex
export db_name=discourse
export db_user=discourse
su postgres -c 'createdb $db_name' || true
su postgres -c 'psql $db_name -c "create user $db_user;"' || true
su postgres -c 'psql $db_name -c "grant all privileges on database $db_name to $db_user;"' || true
su postgres -c 'psql $db_name -c "alter schema public owner to $db_user;"'
su postgres -c 'psql template1 -c "create extension if not exists hstore;"'
su postgres -c 'psql template1 -c "create extension if not exists pg_trgm;"'
su postgres -c 'psql $db_name -c "create extension if not exists hstore;"'
su postgres -c 'psql $db_name -c "create extension if not exists pg_trgm;"'