Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrx = read('classpath:helpers/Bodytrx.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set bodyTrx.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrx.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * set bodyTrx.payload[0].payment.taxBase = dataGenerator.getRandomValueReceipt()
    * set bodyTrx.payload[0].commerce.atmId = dataGenerator.getRandomValueCajero()
    * set bodyTrx.payload[0].paymentMethod.card = dataGenerator.getRandomValueCard()
    * def dateTimes = karate.call('classpath:helpers/dateTime.js')
    * set bodyTrx.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrx.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrx.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion con firma
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '00'
    And request bodyTrx.payload[0].notification.notificationFlag = "<notiAprobada>"
    And request bodyTrx.payload[0].notification.notificationType = "<tipoA>"
    And request bodyTrx.payload[0].notification.cellphone = "3177928280"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    * eval sleep(15000)
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '85'
    And request bodyTrx.payload[0].notification.notificationFlag = "<notiReversada>"
    And request bodyTrx.payload[0].notification.notificationType = "<tipoB>"
    And request bodyTrx.payload[0].notification.cellphone = "3177928280"
    And request bodyTrx
    When method post
    Then status 200
    * eval sleep(24)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '85'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | notiAprobada | tipoA | notiReversada | tipoB |
      #| true         | 1     | true          | 1     | # notifica2
      #| false        | 1     | true          | 1     | # notifica1
      #| true         | 1     | false         | 1     | # notifica2
      #| false        | 1     | false         | 1     |
      #| true         | 2     | true          | 2     | # notifica2
      #| false        | 2     | true          | 2     | # notifica1
      #| true         | 2     | false         | 2     | # notifica2
      #-| false        | 2     | false         | 2     |
      #| true         | 1     | true          | 2     | # notifica2
      #| false        | 1     | true          | 2     | # notifica1
      #-| true         | 1     | false         | 2     | # notifica2
      #-| false        | 1     | false         | 2     |
      #| true         | 2     | true          | 1     | # notifica2
      #-| false        | 2     | true          | 1     | # notifica1
      #| true         | 2     | false         | 1     | # notifica2
      #-| false        | 2     | false         | 1     |