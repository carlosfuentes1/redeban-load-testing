Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helpersCorr/commerce/BodyCommerceFull.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helpersCorr.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helpersCorr/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].commerce.commerceId = <commerceId>
    And request bodyTrxCorr.payload[0].commerce.terminalId = <terminalId>
    And request bodyTrxCorr.payload[0].commerce.techVersion = <techVersion>
    And request bodyTrxCorr.payload[0].commerce.atmId = <atmId>
    And request bodyTrxCorr.payload[0].commerce.COD = <COD>
    And request bodyTrxCorr
    When method post
    Then status 200
    * eval sleep(01)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.responseCode == '00'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | commerceId               | terminalId   | techVersion        | atmId        | COD   |
      | 0123456789               | 0123456789   | 0123456789         | 0123456789   | 0123  | # solo numéricos
      | QWERtyJD                 | QWERtyJD     | QWERtyJD           | QWERtyJD     | QWER  | # solo texto
      | @!!"#$%&                 | @!!"#$%&     | @!!"#$%&           | @!!"#$%&     | @!!"  | # solo caracteres especiales
      | 123@$%COD                | 123@$%COD    | 123@$%COD          | 123@$%COD    | 1@CO  | # solo alfanuméricos
      |                          |              |                    |              |       | # solo nulos
      | ""                       | ""           | ""                 | ""           | ""    | # solo vacíos
      | 123456789012345678901234 | 123456789JDD | 1234567890ABCDÑÑÑÑ | 123456789JDD | 12345 | # tamaño desborde
      | 1098 733994              | LEAL 041TE   | PAX 2.81R          | CAJE O10@    | 00 1  | # Correctos standard con espacios
      | 12345678901234567890123  | 123456789JD  | 1234567890ABCDÑÑ   | 12345ABCDÑ   | 1234  | # Correctos límite máximo
      | 1                        | a            | 1                  | 1            | 1     | # Correctos límite mínimo
      | 1098733994               | LEAL0041TE   | PAX 2.81R          | CAJERO10@    | 0001  | # Correctos standard