Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrx = read('classpath:helper/status/StatusFull.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrx.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrx.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrx.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrx.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion con firma
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '00'
    And request bodyTrx.payload[0].paymentMethod.accountType = '<accountType>'
    And request bodyTrx.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    * eval sleep(1000)
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '05'
    And request bodyTrx.payload[0].paymentMethod.accountType = '<accountType>'
    And request bodyTrx.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '05'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    * eval sleep(1000)
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '85'
    And request bodyTrx.payload[0].paymentMethod.accountType = '<accountType>'
    And request bodyTrx.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '85'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    * eval sleep(1000)
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '05'
    And request bodyTrx.payload[0].paymentMethod.accountType = '<accountType>'
    And request bodyTrx.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '05'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | accountType | transactionType      |
      | AH          | TRANSFERENCIA AHORRO |
      | CC          | TRANSFERENCIA AHORRO |
      | CR          | TRANSFERENCIA AHORRO |
      | 00          | TRANSFERENCIA AHORRO |
      | AH          | TRANSFERENCIA CORRIENTE |
      | CC          | TRANSFERENCIA CORRIENTE |
      | CR          | TRANSFERENCIA CORRIENTE |
      | 00          | TRANSFERENCIA CORRIENTE |
      | AH          | TRANSFERENCIA OTRA CTA |
      | CC          | TRANSFERENCIA OTRA CTA |
      | CR          | TRANSFERENCIA OTRA CTA |
      | 00          | TRANSFERENCIA OTRA CTA |
      | AH          | RETIRO |
      | CC          | RETIRO |
      | CR          | RETIRO |
      | 00          | RETIRO |
      | AH          | AHORRO A LA MANO |
      | CC          | AHORRO A LA MANO |
      | CR          | AHORRO A LA MANO |
      | 00          | AHORRO A LA MANO |
      | AH          | RETIRO NEQUI |
      | CC          | RETIRO NEQUI |
      | CR          | RETIRO NEQUI |
      | 00          | RETIRO NEQUI |
      | AH          | RETIRO PAGOS |
      | CC          | RETIRO PAGOS |
      | CR          | RETIRO PAGOS |
      | 00          | RETIRO PAGOS |
      | AH          | DEPOSITO AHORROS |
      | CC          | DEPOSITO AHORROS |
      | CR          | DEPOSITO AHORROS |
      | 00          | DEPOSITO AHORROS |
      | AH          | DEPOSITO CORRIENTE |
      | CC          | DEPOSITO CORRIENTE |
      | CR          | DEPOSITO CORRIENTE |
      | 00          | DEPOSITO CORRIENTE |
      | AH          | RECARGA NEQUI |
      | CC          | RECARGA NEQUI |
      | CR          | RECARGA NEQUI |
      | 00          | RECARGA NEQUI |
      | AH          | PAGO FACTURA MANUAL |
      | CC          | PAGO FACTURA MANUAL |
      | CR          | PAGO FACTURA MANUAL |
      | 00          | PAGO FACTURA MANUAL |
      | AH          | PAGO FACT. CÓD BARRAS |
      | CC          | PAGO FACT. CÓD BARRAS |
      | CR          | PAGO FACT. CÓD BARRAS |
      | 00          | PAGO FACT. CÓD BARRAS |
      | AH          | PAGO FACT. TARJ EMPRES |
      | CC          | PAGO FACT. TARJ EMPRES |
      | CR          | PAGO FACT. TARJ EMPRES |
      | 00          | PAGO FACT. TARJ EMPRES |
      | AH          | PAGO TARJETA DE CRÉDITO |
      | CC          | PAGO TARJETA DE CRÉDITO |
      | CR          | PAGO TARJETA DE CRÉDITO |
      | 00          | PAGO TARJETA DE CRÉDITO |
      | AH          | PAGO CARTERA |
      | CC          | PAGO CARTERA |
      | CR          | PAGO CARTERA |
      | 00          | PAGO CARTERA |
      | AH          | CONSULTA DE SALDO |
      | CC          | CONSULTA DE SALDO |
      | CR          | CONSULTA DE SALDO |
      | 00          | CONSULTA DE SALDO |
      | AH          | CONSULTAR CUPO |
      | CC          | CONSULTAR CUPO |
      | CR          | CONSULTAR CUPO |
      | 00          | CONSULTAR CUPO |
      | AH          | CAMBIO DE CLAVE |
      | CC          | CAMBIO DE CLAVE |
      | CR          | CAMBIO DE CLAVE |
      | 00          | CAMBIO DE CLAVE |