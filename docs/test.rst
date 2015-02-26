Test gasista felice
===================

Per eseguire i test son necessari i seguenti passi:

- installare phantomjs::

    pacman -S phantomjs

- installare casperjs con npm::

    npm install casperjs

- esportare la path dell'eseguibile di casperjs::

    export PATH=$PATH:path_to_casper_bin

- importare il db nell'applicazione web::

    psql -U gf_dev -d gf_dev < db_dump.sql

- lanciare il webserver::

    manage.py runserver

- lanciare i tests::

    casperjs test.js
