# Intergas Order test 
# This will try to login as admin, impersonate an user and then
# add an InterGAS scheduled order.

c = casper
c.test.begin 'Intergas Order test', 2, (test) ->
    c.start 'http://localhost:8000'
    c.then ->
        test.assertTitle 'GASISTA FELICE', 'Main page loaded'
        # filling the above from will redirect to the default logged user page
        this.fill 'form', {
                    username: 'admin',
                    password: 'lJgistcZsVnQV2M'
                  }, true ; return
    c.then ->
        test.assertTitle 'GF - Gestione des', 'Logged user page loaded' ; return
    c.thenEvaluate ->
        # select the user to simulate and get redirected again
        $('#user_to_simulate').val '3'
        $('#user_to_simulate').change() ; return
    # go to the gas page
    c.thenOpen 'http://localhost:8000/gasistafelice/rest/#rest/gas/11'
    c.thenEvaluate ->
        # switch to order section
        document.querySelector 'a[title=orders]'.click() ; return
    c.then ->
        c.waitForSelector '.block_action'
    c.thenEvaluate ->
        # click on the 'add order' button
        $('.block_action').click() ; return
    # fill the form and submit
    c.then ->
        this.fill '#gassupplierorder_form', {
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
            } , true ; return
    c.run ->
        test.done() ; return
    return
