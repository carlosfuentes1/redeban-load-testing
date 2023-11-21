Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/camposObligatorios/CamposObligatoriosTransactionType.json')
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
    And request bodyTrxCorr.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrxCorr
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | transactionType         |
      #| TRANSFERENCIA AHORRO    |
      #| TRANSFERENCIA CORRIENTE |
      #| TRANSFERENCIA OTRA CTA  |
      #| RETIRO                  |
      #| AHORRO A LA MANO        |
      #| RETIRO NEQUI            |
      #| RETIRO PAGOS            |
      #| DEPOSITO AHORROS        |
      #| DEPOSITO CORRIENTE      |
      #| RECARGA NEQUI           |
      #| PAGO FACTURA MANUAL     |
      #| PAGO FACT. CÓD BARRAS |
      #| PAGO FACT. TARJ EMPRES  |
      | PAGO TARJETA DE CRÉDITO |
      #| PAGO CARTERA            |
      #| CONSULTA DE SALDO       |
      #| CONSULTAR CUPO          |
      #| CAMBIO DE CLAVE         |