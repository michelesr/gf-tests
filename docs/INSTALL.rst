Installation
============

Using NPM
-------------------

Install casperjs and phantomjs with npm::

    $ npm install casperjs

You need to export path of casper and phantom binaries::

    $ PATH=$PATH:$PWD/node_modules/casperjs/node_modules/phantomjs/bin/:$PWD/node_modules/casperjs/bin/

To install system-wide instead::

    # npm install -g casperjs

Import the db::

    $ cd db
    $ ./reset_db.sh

If the script doesn't work, try launching as root or postgres user, or refer to
Gasista Felice guide for importing a db.

The default db owner is ``gf_dev``, change that if needed, replacing the values
in ``db_test.sql``.

Go to source directory::

    $ cd ../src/

Open the ``settings.json`` file and set ``"locahost"`` as ``hostname``.

In order to start the tests you need to start the development webserver, please
refer to Gasista Felice installation guide.

To launch the test::

    $ casperjs test test.coffee

Using a docker image
--------------------

Get the casperjs image::

    $ docker pull philalex/docker-casperjs

Go to the source directory::

    $ cd src/

The settings.json should be configured to the right hostname and port, just make
sure to expose the webserver to the network interface when you start it::

    $ manage.py runserver 0.0.0.0:8000

Open a shell inside the docker container::

    $ docker run -v $PWD:/mnt/test/ --rm -it philalex/docker-casperjs bash -il
    
From inside the container::

    $ cd /mnt/test

Launch the test::

    $ casperjs test test.coffee
