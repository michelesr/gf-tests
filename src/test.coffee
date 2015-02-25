# Intergas Order test 
# This will try to login as admin, impersonate an user and then
# add an InterGAS scheduled order.

c = casper
c.test.begin 'Intergas Order test', 5, (test) ->
    c.start 'http://localhost:8000'
    c.then ->
        test.assertTitle 'GASISTA FELICE', 'Main page loaded'
        this.echo 'Starting authentication'
        this.fill 'form', {
                    username: 'admin',
                    password: 'lJgistcZsVnQV2M'
                  }, true ; return
    c.then ->
        test.assertTitle 'GF - Gestione des', 'Logged user page loaded'
        this.echo 'Switching to Dom user' ; return
    c.thenEvaluate ->
        $('#user_to_simulate').val '3'
        $('#user_to_simulate').change() ; return
    c.then ->
       this.echo 'Waiting for GasProva link'
       c.waitForSelector 'a[href="#rest/gas/11"]' ; return
    c.then ->
       this.echo 'Clicking GasProva link'
       this.click 'a[href="#rest/gas/11"]' ; return
    c.then ->
        this.echo 'Waiting for page GasProva'
        c.waitFor ->
            this.getTitle() == 'GF - Gestione gas'
        return
    c.then ->
        test.assertTitle 'GF - Gestione gas', 'GasProva page' ; return
    c.then ->
        this.echo 'Waiting for the orders tab selector'
        c.waitForSelector 'a[title="orders"]' ; return
    c.then ->
        this.echo 'Clickin on order tabs'
        this.click 'a[title="orders"]' ; return
    c.then ->
        this.echo 'Waiting for add order button'
        c.waitForSelector '.block_action' ; return
    c.then ->
        this.echo 'Clicking add order button'
        this.click '.block_action'
        this.echo 'Waiting for the form'
        c.waitForSelector '#gassupplierorder_form' ; return
    c.then ->
        this.echo 'Filling the form'
        obj =
            pact: '15'
            datetime_start_0: '24/02/2015'
            datetime_start_1: '18:00'
            datetime_end_0: '07/03/2015'
            datetime_end_1: '18:00'
            delivery_datetime_0: '10/03/2015'
            delivery_datetime_1: '20:00'
            referrer_person: '5'
            repeat_order: 'on'
            repeat_frequency: '28'
            repeat_until_date: '24/05/2015'
            intergas: 'on'
            intergas_grd: '16'

        for k, v of obj
            this.echo "    #{k}: \"#{v}\""
        this.fill '#gassupplierorder_form', obj  , false ; return
    c.then ->
        this.echo 'Clicking on submit button'
        this.click '.ui-button' ; return
    c.then ->
        this.echo 'Waiting...'
        this.wait 10000 ; return
    c.then ->
        test.assertTitle 'GF - Gestione gas', 'Page reloaded' ; return
        this.echo 'Checkin number of orders'
        c.waitForSelector('.odd')
        c.waitForSelector('.even') ; return
    c.then ->
        this.echo 'Testing that scheduled order are 3'
        test.assertElementCount '.even, .odd', 3 ; return
    c.then ->
        this.echo 'Capturing a screenshoot of the page on screenshoot.png'
        this.capture 'screenshot.png'
    c.run ->
        test.done() ; return
    return
