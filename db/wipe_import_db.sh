#! /bin/sh

dropdb -U postgres gf_dev
createdb -U postgres -O gf_dev -E utf-8 -T template0 gf_dev
psql -U postgres -d gf_dev < db_test.sql

