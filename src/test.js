// Generated by CoffeeScript 1.9.1
(function() {
  var c;

  c = casper;

  c.test.begin('Intergas Order test', 5, function(test) {
    c.start('http://localhost:8000');
    c.then(function() {
      test.assertTitle('GASISTA FELICE', 'Main page loaded');
      this.echo('Starting authentication');
      this.fill('form', {
        username: 'admin',
        password: 'lJgistcZsVnQV2M'
      }, true);
    });
    c.then(function() {
      test.assertTitle('GF - Gestione des', 'Logged user page loaded');
      this.echo('Switching to Dom user');
    });
    c.thenEvaluate(function() {
      $('#user_to_simulate').val('3');
      $('#user_to_simulate').change();
    });
    c.then(function() {
      this.echo('Waiting for GasProva link');
      c.waitForSelector('a[href="#rest/gas/11"]');
    });
    c.then(function() {
      this.echo('Clicking GasProva link');
      this.click('a[href="#rest/gas/11"]');
    });
    c.then(function() {
      this.echo('Waiting for page GasProva');
      c.waitFor(function() {
        return this.getTitle() === 'GF - Gestione gas';
      });
    });
    c.then(function() {
      test.assertTitle('GF - Gestione gas', 'GasProva page');
    });
    c.then(function() {
      this.echo('Waiting for the orders tab selector');
      c.waitForSelector('a[title="orders"]');
    });
    c.then(function() {
      this.echo('Clickin on order tabs');
      this.click('a[title="orders"]');
    });
    c.then(function() {
      this.echo('Waiting for add order button');
      c.waitForSelector('.block_action');
    });
    c.then(function() {
      this.echo('Clicking add order button');
      this.click('.block_action');
      this.echo('Waiting for the form');
      c.waitForSelector('#gassupplierorder_form');
    });
    c.then(function() {
      var k, obj, v;
      this.echo('Filling the form');
      obj = {
        pact: '15',
        datetime_start_0: '24/02/2015',
        datetime_start_1: '18:00',
        datetime_end_0: '07/03/2015',
        datetime_end_1: '18:00',
        delivery_datetime_0: '10/03/2015',
        delivery_datetime_1: '20:00',
        referrer_person: '5',
        repeat_order: 'on',
        repeat_frequency: '28',
        repeat_until_date: '24/05/2015',
        intergas: 'on',
        intergas_grd: '16'
      };
      for (k in obj) {
        v = obj[k];
        this.echo("    " + k + ": \"" + v + "\"");
      }
      this.fill('#gassupplierorder_form', obj, false);
    });
    c.then(function() {
      this.echo('Clicking on submit button');
      this.click('.ui-button');
    });
    c.then(function() {
      this.echo('Waiting...');
      this.wait(10000);
    });
    c.then(function() {
      test.assertTitle('GF - Gestione gas', 'Page reloaded');
      return;
      this.echo('Checking number of orders');
      c.waitForSelector('.odd');
      c.waitForSelector('.even');
    });
    c.then(function() {
      this.echo('Testing that scheduled orders are 3');
      test.assertElementCount('.even, .odd', 3, 'Orders count match');
    });
    c.then(function() {
      this.echo('Capturing a screenshoot of the page on screenshoot.png');
      return this.capture('screenshot.png');
    });
    c.run(function() {
      test.done();
    });
  });

}).call(this);