Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrx = read('classpath:payloads/BodyTrxAdquirencia.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * def NumReceipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrx.payload[0].transaction.receipt = NumReceipt
    * set bodyTrx.payload[0].payment.fullAmount = NumReceipt
    * set bodyTrx.payload[0].payment.taxBase = NumReceipt
    * set bodyTrx.payload[0].transaction.rrn = NumReceipt
    * set bodyTrx.payload[0].paymentMethod.card = dataGenerator.getRandomValueCard()
    * set bodyTrx.payload[0].commerce.atmId = dataGenerator.getRandomValueCajero()
    * set bodyTrx.payload[0].transaction.rrn = NumReceipt
    * set bodyTrx.payload[0].transaction.approvalNum = NumReceipt
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
    And request bodyTrx.payload[0].paymentMethod.accountType = "<accountType>"
    And request bodyTrx.payload[0].paymentMethod.franchise = "<franchise>"
    And request bodyTrx.payload[0].transaction.transactionType = "<transactionType>"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    * eval sleep(700)
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '05'
    And request bodyTrx.payload[0].paymentMethod.accountType = "<accountType>"
    And request bodyTrx.payload[0].paymentMethod.franchise = "<franchise>"
    And request bodyTrx.payload[0].transaction.transactionType = "<transactionType>"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '05'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | accountType | franchise    |transactionType|
      | AH          | AMEX         |VENTA          |
#      | CC          | BCO_SUP      |LEALTAD        |
#      | CR          | DINERSCLUB   |PUNTOS COLOMBIA|
#      | LT          | MAESTRO      |LEALTADPLUS    |
#      | CM          | CREDENCIAL   |T. PRIVADA     |
#      | CU          | MASTERCARD   |TOTAL BONOS    |
#      | BE          | VISA DEBIT   |BONOS RECARGABLES|
#      | RT          | V.ELECTRON   |PCR              |
#      | RG          | CREDITO P    |RECARGA EFECTIVO |
#      | DS          | T. ALKOSTO   |RECARGAS         |
#      | BC          | TUYA         |EFECTIVO         |
#      | BD          | PRIVADACR    |IMPUESTOS        |
#      | SP          | CREDENVISA   |WIZEO            |
#      | 00          | COLSUBISIDIO |OPS              |
#      | LT          | CAJA C.F.    |LIFEMILES        |
#      | CM          | T. PRIVADA   |QR               |
#      | CU          | T. CREDITO   |PSP              |
#      | LC          | T. EXITO     |NODATA           |
#      | MD          | C.M.R        |VENTA            |
#      | AM          | TARL TCO     |LEALTAD          |
#      | NC          | PRIVADA      |PUNTOS COLOMBIA  |
#      | -           | CREDITOPR    |LEALTADPLUS      |
#      | AH          | BONO CODEN   |T. PRIVADA       |
#      | CC          | BONOS        |TOTAL BONOS      |
#      | CR          | SODEXO       |BONOS RECARGABLES|
#      | LT          | BIG PASS     |PCR              |
#      | CM          | BTERA.OTP    |RECARGA EFECTIVO |
#      | CU          | PTOSCOLMB    |RECARGAS         |
#      | BE          | LIFEMILES    |EFECTIVO         |
#      | RT          | MASTER DEBI  |IMPUESTOS        |
#      | RG          | MASTER       |WIZEO            |
#      | DS          | MASTERD      |OPS              |
#      | BC          | MASTER DEB   |QR               |
#      | BD          | MASTER DEBIT |LIFEMILES        |
#      | SP          | VISA         |PSP              |
#      | 00          | DINERS       |NODATA           |