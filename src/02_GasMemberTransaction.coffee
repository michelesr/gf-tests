fs = require 'fs'
settings = JSON.parse fs.read 'settings.json'
c = casper
c.timeout = 20000

c.dumpObject = (obj) ->
  for k, v of obj
    @echo "  #{k}: '#{v}'"

c.decimalRound = (x) ->
  (Math.round (x * 100)) / 100

c.getRandomImport = ->
  c.decimalRound(Math.random() * 100)

c.getBalance = ->
  c.evaluate ->
    parseFloat($('#id_balance').val().replace('€', '.'))
  
gasmember = {}
gas = {}

c.test.begin 'Transaction test', 8, (test) ->
  c.start "http://#{settings.hostname}:#{settings.port}/"

  c.then ->
    if @getTitle() == 'GASISTA FELICE'
      @echo 'Starting authentication'
      auth =
        username: 'admin'
        password: 'admin'
      @fill 'form', auth, true
      @echo 'Waiting for logged user page'
      c.waitFor ->
        @getTitle() == 'GF - Gestione des'

  c.then ->
    @echo 'Waiting for link to gasmember 1 page'
    c.waitForSelector 'a[href="#rest/gasmember/1"]'

  c.then ->
    @click 'a[href="#rest/gasmember/1"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gasmember'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    gasmember.balance = c.getBalance()
    @echo "Balance = #{gasmember.balance}"
    gasmember.detraction = c.getRandomImport()
    @echo "Starting detraction (asset) for an amount of #{gasmember.detraction}"
    obj =
      amount: gasmember.detraction
      target: 'ASSET'
      causal: 'Testing detraction'
    @echo 'Filling the form:'
    c.dumpObject(obj)
    @fill '#fbalancegm', obj, true
    @echo 'Submiting and waiting:'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"

   c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    expectedBalance = c.decimalRound(gasmember.balance - gasmember.detraction)
    test.assertEqual c.getBalance(), expectedBalance,
      'Member Balance is correct after detraction (asset)'
    gasmember.balance = c.getBalance()
    @echo "Balance = #{gasmember.balance}"
    gasmember.increment = c.getRandomImport()
    @echo "Starting balance increment (liability)" +
      "for an amount of #{gasmember.increment}"
    obj =
      amount: gasmember.increment
      target: 'LIABILITY'
      causal: 'Testing increment'
    @echo 'Filling the form:'
    c.dumpObject(obj)
    @fill '#fbalancegm', obj, true
    @echo 'Submiting and waiting:'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"

   c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    expectedBalance = c.decimalRound(gasmember.balance + gasmember.increment)
    test.assertEqual c.getBalance(), expectedBalance,
      'Member Balance is correct after increment (liability)'
    gasmember.balance = c.getBalance()
    @echo "Gasmember Balance = #{gasmember.balance}"
    c.waitForSelector 'a[href="#rest/gas/1/"]'

  c.then ->
    @echo 'Opening link to gas page'
    @click 'a[href="#rest/gas/1/"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gas'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the balance'
    c.waitForSelector '#id_balance'

  c.then ->
    gas.balance = c.getBalance()
    @echo "GAS Balance: #{gas.balance}"
    @echo 'Coming back to gasmember page'
    @click 'a[href="#rest/gasmember/1"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gasmember'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    gasmember.balance = c.getBalance()
    @echo "Balance = #{gasmember.balance}"
    gasmember.detraction = c.getRandomImport()
    @echo "Starting detraction (expense) for an amount of" +
      " #{gasmember.detraction}"
    obj =
      amount: gasmember.detraction
      target: 'EXPENSE'
      causal: 'Testing expense'
    @echo 'Filling the form:'
    c.dumpObject(obj)
    @fill '#fbalancegm', obj, true
    @echo 'Submiting and waiting:'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"
   

  c.then ->
    @echo 'Opening link to gas page'
    @click 'a[href="#rest/gas/1/"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gas'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the balance'
    c.waitForSelector '#id_balance'

  c.then ->
    expectedBalance = c.decimalRound(gas.balance + gasmember.detraction)
    test.assertEqual c.getBalance(), expectedBalance,
      'Gas balance is correct after gasmember detraction (expense)'
    gas.balance = c.getBalance()
    @echo 'Coming back to gasmember page'
    @click 'a[href="#rest/gasmember/1"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gasmember'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    expectedBalance = c.decimalRound(gasmember.balance - gasmember.detraction)
    test.assertEqual c.getBalance(), expectedBalance,
      'Member Balance is correct after expense operation'
    gasmember.balance = c.getBalance()
    @echo "Balance = #{gasmember.balance}"
    gasmember.increment = c.getRandomImport()
    @echo "Starting balance increment (income) for an amount of" +
      " #{gasmember.increment}"
    obj =
      amount: gasmember.increment
      target: 'INCOME'
      causal: 'Testing income'
    @echo 'Filling the form:'
    c.dumpObject(obj)
    @fill '#fbalancegm', obj, true
    @echo 'Submiting and waiting:'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"

  c.then ->
    @echo 'Opening link to gas page'
    @click 'a[href="#rest/gas/1/"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gas'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the balance'
    c.waitForSelector '#id_balance'

  c.then ->
    expectedBalance = c.decimalRound(gas.balance - gasmember.increment)
    test.assertEqual c.getBalance(), expectedBalance,
      'Gas balance is correct after gasmember increment (income)'
    gas.balance = c.getBalance()
    @echo 'Coming back to gasmember page'
    @click 'a[href="#rest/gasmember/1"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gasmember'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    expectedBalance = c.decimalRound(gasmember.balance + gasmember.increment)
    test.assertEqual c.getBalance(), expectedBalance,
      'Member Balance is correct after income operation'
    gasmember.balance = c.getBalance()
    @echo "Balance = #{gasmember.balance}"
    gasmember.increment = c.getRandomImport()
    @echo "Starting balance increment (equity) for an amount of" +
      " #{gasmember.increment}"
    obj =
      amount: gasmember.increment
      target: 'EQUITY'
      causal: 'Testing equity'
    @echo 'Filling the form:'
    c.dumpObject(obj)
    @fill '#fbalancegm', obj, true
    @echo 'Submiting and waiting:'
    c.waitFor ->
      c.evaluate ->
        $('#loading-container').css('display') is "none"

  c.then ->
    @echo 'Opening link to gas page'
    @click 'a[href="#rest/gas/1/"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gas'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the balance'
    c.waitForSelector '#id_balance'

  c.then ->
    expectedBalance = c.decimalRound(gas.balance - gasmember.increment)
    test.assertEqual c.getBalance(), expectedBalance,
      'Gas balance is correct after gasmember increment (equity)'
    gas.balance = c.getBalance()
    @echo 'Coming back to gasmember page'
    @click 'a[href="#rest/gasmember/1"]'
    c.waitFor ->
      @getTitle() == 'GF - Gestione gasmember'

  c.then ->
    @echo 'Waiting for the accounting tab selector'
    c.waitForSelector 'a[title="accounting"]'

  c.then ->
    @click 'a[title="accounting"]'
    @echo 'Waiting for the form'
    c.waitForSelector '#fbalancegm'

  c.then ->
    expectedBalance = c.decimalRound(gasmember.balance + gasmember.increment)
    test.assertEqual c.getBalance(), expectedBalance,
      'Member Balance is correct after equity operation'

  c.run ->
    test.done()
