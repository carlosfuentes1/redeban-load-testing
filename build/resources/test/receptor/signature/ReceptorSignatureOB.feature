Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helpersCorr/signature/BodySignatureOB.json')
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
    And request bodyTrxCorr.payload[0].signature.signatureFlag = <signatureFlag>
    And request bodyTrxCorr
    When method post
    Then status 200
    * eval sleep(01)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.responseCode == '00'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | signatureFlag            |
      | 0123456789               | # solo numéricos
      | QWERtyJD                 | # solo texto
      | @!!"#$%&                 | # solo caracteres especiales
      | 123@$%COD                | # solo alfanuméricos
      |                          | # solo nulos
      | ""                       | # solo vacíos
      | falsee                   | # tamaño desborde
      | fal se                   | # Correctos standard con espacios
      | true                     | # Correctos límite máximo
      | false                    | # Correctos límite mínimo
      | true                     | # Correctos standard