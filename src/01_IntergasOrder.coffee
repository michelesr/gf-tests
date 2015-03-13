# Intergas Order test. This will try to login as admin,
# impersonate an user and then add an InterGAS scheduled order.

fs = require 'fs'
settings = JSON.parse fs.read 'settings.json'
c = casper
c.timeout = 20000

c.test.begin 'Intergas Order test', 4, (test) ->
  c.start "http://#{settings.hostname}:#{settings.port}/"

  c.then ->
    test.assertTitle 'GASISTA FELICE', 'Main page loaded'
    @echo 'Starting authentication'
    auth =
      username: 'admin'
      password: 'admin'
    @fill 'form', auth, true
    @echo 'Waiting for logged user page'
    c.waitFor ->
      @getTitle() == 'GF - Gestione des'

  c.then ->
    test.assertTitle 'GF - Gestione des', 'Logged user page loaded'
    @echo 'Switching to 01gas1 - Gasista_01 DelGas_01'

  c.thenEvaluate ->
    $('#user_to_simulate').val '2'
    $('#user_to_simulate').change()

  c.then ->
    @echo 'Waiting for Gas01 link'
    c.waitForSelector 'a[href="#rest/gas/1"]'

  c.then ->
    @echo 'Clicking Gas01 link'
    @click 'a[href="#rest/gas/1"]'
    @echo 'Waiting for page Gas01'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gas'

  c.then ->
    test.assertTitle 'GF - Gestione gas', 'Gas01 page'
    @echo 'Waiting for the orders tab selector'
    c.waitForSelector 'a[title="orders"]'

  c.then ->
    @echo 'Clickin on order tabs'
    @click 'a[title="orders"]'
    @echo 'Waiting for add order button'
    c.waitForSelector '.block_action'

  c.then ->
    @echo 'Clicking add order button'
    @click '.block_action'
    @echo 'Waiting for the form'
    c.waitForSelector '#gassupplierorder_form'

  c.then ->
    @echo 'Filling the form'
    obj =
      pact: '3'
      datetime_start_0: '24/02/2015'
      datetime_start_1: '18:00'
      datetime_end_0: '07/03/2015'
      datetime_end_1: '18:00'
      delivery_datetime_0: '10/03/2015'
      delivery_datetime_1: '20:00'
      referrer_person: '2'
      repeat_order: 'on'
      repeat_frequency: '28'
      repeat_until_date: '24/05/2015'
      intergas: 'on'
      intergas_grd: '2'
    for k, v of obj
      @echo "  #{k}: '#{v}'"
    @fill '#gassupplierorder_form', obj, false
    @echo 'Clicking on submit button'
    @click '.ui-button'
    @echo 'Waiting...'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"

  c.then ->
    @echo 'Checking number of orders'
    c.waitForSelector '.odd'
    c.waitForSelector '.even'

  c.then ->
    @echo 'Testing that scheduled orders are 3'
    test.assertElementCount '.even, .odd', 3, 'Orders count match'
    @echo 'Capturing a screenshot of the page on screenshot.png'
    @capture 'screenshot.png'

  c.run ->
    test.done()
