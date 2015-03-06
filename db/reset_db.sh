#! /bin/sh
#
# Reset the db for a new session of tests. 
# Use also to import db the first time.

dropdb -U postgres gf_dev
createuser -U postgres -D -A gf_dev
createdb -U postgres -O gf_dev -E utf-8 -T template0 gf_dev
psql -U postgres -d gf_dev < db_test.sql
