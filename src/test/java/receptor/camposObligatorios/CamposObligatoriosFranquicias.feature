Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/camposObligatorios/CamposObligatoriosFranquicias.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia


  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].paymentMethod.franchise = '<franchise>'
    And request bodyTrxCorr
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | franchise  |
      | AMEX         |
      | BCO_SUP      |
      | DINERSCLUB   |
      | MAESTRO      |
      | CREDENCIAL   |
      | MASTERCARD   |
      | VISA DEBIT   |
      | V.ELECTRON   |
      | CREDITO P    |
      | T. ALKOSTO   |
      | TUYA         |
      | PRIVADACR    |
      | CREDENVISA   |
      | COLSUBISIDIO |
      | CAJA C.F.    |
      | T. PRIVADA   |
      | T. CREDITO   |
      | T. EXITO     |
      | C.M.R        |
      | TARL TCO     |
      | PRIVADA      |
      | CREDITOPR    |
      | BONO CODEN   |
      | BONOS        |
      | SODEXO       |
      | BIG PASS     |
      | BTERA.OTP    |
      | PTOSCOLMB    |
      | LIFEMILES    |
      | MASTER DEBI  |
      | MASTER       |
      | MASTERD      |
      | MASTER DEB   |
      | MASTER DEBIT |
      | VISA         |
      | DINERS       |
