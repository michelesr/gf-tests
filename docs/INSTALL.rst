Installation
============

Using NPM
-------------------

Install *casperjs* with *npm* package manager::

    $ npm install casperjs

You need to export path of casper and phantom binaries::

    $ export PATH=$PATH:$PWD/node_modules/casperjs/node_modules/phantomjs/bin/:$PWD/node_modules/casperjs/bin/

To install system-wide instead::

    # npm install -g casperjs

Navigate to database directory::

    $ cd db

The default db owner is ``gf_dev``, change that if needed, replacing the values
in ``db_test.sql``.

Import the db::

    $ ./reset_db.sh

If the script doesn't work, try launching as *root* or *postgres* user, or refer to
Gasista Felice guide for importing a db.

Go to source directory::

    $ cd ../src/

Open the ``settings.json`` file and set ``localhost`` as *hostname*.

In order to start the tests you need to start the development webserver, please
refer to Gasista Felice installation guide.

To launch the test::

    $ casperjs test test.coffee

Using a docker image
--------------------

Get the casperjs image::

    $ docker pull philalex/docker-casperjs

Import the db as explained above.

Go to the source directory::

    $ cd src/

The ``settings.json`` should be configured to the right *hostname* and *port*, just make
sure to expose the *webserver* to the network interface when you start it::

    $ manage.py runserver 0.0.0.0:8000



Open a shell inside the docker container::

    $ docker run -v $PWD:/mnt/test/ --rm -it philalex/docker-casperjs bash -il
    
From inside the container::

    $ cd /mnt/test

Launch the test::

    $ casperjs test test.coffee
    
If phantom can't connect to the webserver, you need to configure the right hostname on ``settings.json``.

Useful links: https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach
