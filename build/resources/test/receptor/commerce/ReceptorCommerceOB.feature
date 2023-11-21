Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/commerce/BodyCommerceOB.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion con firma
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].commerce.commerceId = <commerceId>
    And request bodyTrxCorr.payload[0].commerce.terminalId = '<terminalId>'
    And request bodyTrxCorr.payload[0].commerce.techVersion = '<techVersion>'
    And request bodyTrxCorr
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | commerceId | terminalId | techVersion |
            # solo numéricos
      #| 0123456789 | 0123456789 | 0123456783333333333333333 | statusDescription | 00     |
      #| QWERtyJD                 | QWERtyJD     | QWERtyJD           | # solo texto
      #| @!!"#$%&                 | @!!"#$%&     | @!!"#$%&           | # solo caracteres especiales
      #| 123@$%COD                | 123@$%COD    | 123@$%COD          | # solo alfanuméricos
      #|                          |              |                    | # solo nulos
      #| ""                       | ""           | ""                 | # solo vacíos
      #| 123456789012345678901234 | 123456789JDD | 1234567890ABCDÑÑÑÑ | # tamaño desborde
      #| 1098 733994              | LEAL 041TE   | PAX 2.81R          | # Correctos standard con espacios
      #| 12345678901234567890123  | 123456789JD  | 1234567890ABCDÑÑ   | # Correctos límite máximo
      #| 1                        | a            | 1                  | # Correctos límite mínimo
      #| 1098733994 | LEAL0041TE | PAX 2.81R   | # Correctos standard