#!/usr/bin/env bash

DB_USER=cmsuser
DB_PASS=password
DB_NAME=database

apt-get update
apt-get upgrade -y
mkdir cms
cd cms
wget --no-check-certificate https://github.com/cms-dev/cms/archive/v1.1.zip
apt-get install -y unzip
unzip v1.1.zip
cd cms-1.1/

apt-get install -y build-essential fpc postgresql postgresql-client \
     gettext python2.7 python-setuptools python-tornado python-psycopg2 \
     python-sqlalchemy python-psutil python-netifaces python-crypto \
     python-tz python-six iso-codes shared-mime-info stl-manual \
     python-beautifulsoup python-mechanize python-coverage python-mock \
     cgroup-lite python-requests python-werkzeug python-gevent

./setup.py build
./setup.py install
usermod -a -G cmsuser vagrant
echo "Databases"
cat << EOF | su - postgres -c psql
CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';
CREATE DATABASE $DB_NAME WITH OWNER $DB_USER;
\c $DB_NAME
ALTER SCHEMA public OWNER TO $DB_USER;
GRANT SELECT ON pg_largeobject TO $DB_USER;
EOF

cmsInitDB

