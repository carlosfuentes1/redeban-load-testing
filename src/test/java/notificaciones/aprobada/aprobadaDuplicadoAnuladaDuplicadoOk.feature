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

    * eval sleep(10000)

    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '05'
    And request bodyTrx.payload[0].notification.notificationFlag = "<notiDuplicado>"
    And request bodyTrx.payload[0].notification.notificationType = "<tipoB>"
    And request bodyTrx.payload[0].notification.cellphone = "3177928280"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '05'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max

    * eval sleep(10000)

    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '02'
    And request bodyTrx.payload[0].notification.notificationFlag = "<notiAnulada>"
    And request bodyTrx.payload[0].notification.notificationType = "<tipoC>"
    And request bodyTrx.payload[0].notification.cellphone = "3177928280"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '02'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max

    * eval sleep(10000)

    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '05'
    And request bodyTrx.payload[0].notification.notificationFlag = "<notiDuplicadoA>"
    And request bodyTrx.payload[0].notification.notificationType = "<tipoD>"
    And request bodyTrx.payload[0].notification.cellphone = "3177928280"
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '05'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | notiAprobada | tipoA | notiDuplicado | tipoB | notiAnulada | tipoC | notiDuplicadoA | tipoD |
      | true         | 1     | true          | 1     | true        | 1     | true           | 1     |# notifica4
      | true         | 1     | true          | 1     | true        | 1     | false          | 1     |# notifica3
      | true         | 1     | true          | 1     | false       | 1     | true           | 1     |# notifica4
      | true         | 1     | false         | 1     | true        | 1     | true           | 1     |# notifica3
      | true         | 1     | true          | 1     | false       | 1     | false          | 1     |# notifica3
      | true         | 1     | false         | 1     | true        | 1     | false          | 1     |# notifica2
      | true         | 1     | false         | 1     | false       | 1     | true           | 1     |# notifica3
      | true         | 1     | false         | 1     | false       | 1     | false          | 1     |# notifica2
      | false        | 1     | false         | 1     | false       | 1     | false          | 1     |
      | false        | 1     | false         | 1     | false       | 1     | true           | 1     |# notifica1
      | false        | 1     | false         | 1     | true        | 1     | false          | 1     |# notifica1
      | false        | 1     | true          | 1     | false       | 1     | false          | 1     |# notifica1
      | false        | 1     | false         | 1     | true        | 1     | true           | 1     |# notifica2
      | false        | 1     | true          | 1     | false       | 1     | true           | 1     |# notifica2
      | false        | 1     | true          | 1     | true        | 1     | false          | 1     |# notifica2
      | false        | 1     | true          | 1     | true        | 1     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-36-----------
      | true         | 1     | true          | 1     | true        | 1     | true           | 2     |# notifica4
      | true         | 1     | true          | 1     | true        | 1     | false          | 2     |# notifica3
      | true         | 1     | true          | 1     | false       | 1     | true           | 2     |# notifica4
      | true         | 1     | false         | 1     | true        | 1     | true           | 2     |# notifica3
      | true         | 1     | true          | 1     | false       | 1     | false          | 2     |# notifica3
      | true         | 1     | false         | 1     | true        | 1     | false          | 2     |# notifica2
      | true         | 1     | false         | 1     | false       | 1     | true           | 2     |# notifica3
      | true         | 1     | false         | 1     | false       | 1     | false          | 2     |# notifica2
      | false        | 1     | false         | 1     | false       | 1     | false          | 2     |
      | false        | 1     | false         | 1     | false       | 1     | true           | 2     |# notifica1
      | false        | 1     | false         | 1     | true        | 1     | false          | 2     |# notifica1
      | false        | 1     | true          | 1     | false       | 1     | false          | 2     |# notifica1
      | false        | 1     | false         | 1     | true        | 1     | true           | 2     |# notifica2
      | false        | 1     | true          | 1     | false       | 1     | true           | 2     |# notifica2
      | false        | 1     | true          | 1     | true        | 1     | false          | 2     |# notifica2
      | false        | 1     | true          | 1     | true        | 1     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-28---W-8-------
      | true         | 1     | true          | 1     | true        | 2     | true           | 1     |# notifica4
      | true         | 1     | true          | 1     | true        | 2     | false          | 1     |# notifica3
      | true         | 1     | true          | 1     | false       | 2     | true           | 1     |# notifica4
      | true         | 1     | false         | 1     | true        | 2     | true           | 1     |# notifica3
      | true         | 1     | true          | 1     | false       | 2     | false          | 1     |# notifica3
      | true         | 1     | false         | 1     | true        | 2     | false          | 1     |# notifica2
      | true         | 1     | false         | 1     | false       | 2     | true           | 1     |# notifica3
      | true         | 1     | false         | 1     | false       | 2     | false          | 1     |# notifica2
      | false        | 1     | false         | 1     | false       | 2     | false          | 1     |
      | false        | 1     | false         | 1     | false       | 2     | true           | 1     |# notifica1
      | false        | 1     | false         | 1     | true        | 2     | false          | 1     |# notifica1
      | false        | 1     | true          | 1     | false       | 2     | false          | 1     |# notifica1
      | false        | 1     | false         | 1     | true        | 2     | true           | 1     |# notifica2
      | false        | 1     | true          | 1     | false       | 2     | true           | 1     |# notifica2
      | false        | 1     | true          | 1     | true        | 2     | false          | 1     |# notifica2
      | false        | 1     | true          | 1     | true        | 2     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-24--W-12--------
      | true         | 1     | true          | 2     | true        | 1     | true           | 1     |# notifica4
      | true         | 1     | true          | 2     | true        | 1     | false          | 1     |# notifica3
      | true         | 1     | true          | 2     | false       | 1     | true           | 1     |# notifica4
      | true         | 1     | false         | 2     | true        | 1     | true           | 1     |# notifica3
      | true         | 1     | true          | 2     | false       | 1     | false          | 1     |# notifica3
      | true         | 1     | false         | 2     | true        | 1     | false          | 1     |# notifica2
      | true         | 1     | false         | 2     | false       | 1     | true           | 1     |# notifica3
      | true         | 1     | false         | 2     | false       | 1     | false          | 1     |# notifica2
      | false        | 1     | false         | 2     | false       | 1     | false          | 1     |
      | false        | 1     | false         | 2     | false       | 1     | true           | 1     |# notifica1
      | false        | 1     | false         | 2     | true        | 1     | false          | 1     |# notifica1
      | false        | 1     | true          | 2     | false       | 1     | false          | 1     |# notifica1
      | false        | 1     | false         | 2     | true        | 1     | true           | 1     |# notifica2
      | false        | 1     | true          | 2     | false       | 1     | true           | 1     |# notifica2
      | false        | 1     | true          | 2     | true        | 1     | false          | 1     |# notifica2
      | false        | 1     | true          | 2     | true        | 1     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-28-----W-8-----
      | true         | 1     | true          | 1     | true        | 2     | true           | 2     |# notifica4
      | true         | 1     | true          | 1     | true        | 2     | false          | 2     |# notifica3
      | true         | 1     | true          | 1     | false       | 2     | true           | 2     |# notifica4
      | true         | 1     | false         | 1     | true        | 2     | true           | 2     |# notifica3
      | true         | 1     | true          | 1     | false       | 2     | false          | 2     |# notifica3
      | true         | 1     | false         | 1     | true        | 2     | false          | 2     |# notifica2
      | true         | 1     | false         | 1     | false       | 2     | true           | 2     |# notifica3
      | true         | 1     | false         | 1     | false       | 2     | false          | 2     |# notifica2
      | false        | 1     | false         | 1     | false       | 2     | false          | 2     |
      | false        | 1     | false         | 1     | false       | 2     | true           | 2     |# notifica1
      | false        | 1     | false         | 1     | true        | 2     | false          | 2     |# notifica1
      | false        | 1     | true          | 1     | false       | 2     | false          | 2     |# notifica1
      | false        | 1     | false         | 1     | true        | 2     | true           | 2     |# notifica2
      | false        | 1     | true          | 1     | false       | 2     | true           | 2     |# notifica2
      | false        | 1     | true          | 1     | true        | 2     | false          | 2     |# notifica2
      | false        | 1     | true          | 1     | true        | 2     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-16---W-20-------
      | true         | 1     | true          | 2     | true        | 2     | true           | 1     |# notifica4
      | true         | 1     | true          | 2     | true        | 2     | false          | 1     |# notifica3
      | true         | 1     | true          | 2     | false       | 2     | true           | 1     |# notifica4
      | true         | 1     | false         | 2     | true        | 2     | true           | 1     |# notifica3
      | true         | 1     | true          | 2     | false       | 2     | false          | 1     |# notifica3
      | true         | 1     | false         | 2     | true        | 2     | false          | 1     |# notifica2
      | true         | 1     | false         | 2     | false       | 2     | true           | 1     |# notifica3
      | true         | 1     | false         | 2     | false       | 2     | false          | 1     |# notifica2
      | false        | 1     | false         | 2     | false       | 2     | false          | 1     |
      | false        | 1     | false         | 2     | false       | 2     | true           | 1     |# notifica1
      | false        | 1     | false         | 2     | true        | 2     | false          | 1     |# notifica1
      | false        | 1     | true          | 2     | false       | 2     | false          | 1     |# notifica1
      | false        | 1     | false         | 2     | true        | 2     | true           | 1     |# notifica2
      | false        | 1     | true          | 2     | false       | 2     | true           | 1     |# notifica2
      | false        | 1     | true          | 2     | true        | 2     | false          | 1     |# notifica2
      | false        | 1     | true          | 2     | true        | 2     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-16---W-20-------
      | true         | 1     | true          | 2     | true        | 1     | true           | 2     |# notifica4
      | true         | 1     | true          | 2     | true        | 1     | false          | 2     |# notifica3
      | true         | 1     | true          | 2     | false       | 1     | true           | 2     |# notifica4
      | true         | 1     | false         | 2     | true        | 1     | true           | 2     |# notifica3
      | true         | 1     | true          | 2     | false       | 1     | false          | 2     |# notifica3
      | true         | 1     | false         | 2     | true        | 1     | false          | 2     |# notifica2
      | true         | 1     | false         | 2     | false       | 1     | true           | 2     |# notifica3
      | true         | 1     | false         | 2     | false       | 1     | false          | 2     |# notifica2
      | false        | 1     | false         | 2     | false       | 1     | false          | 2     |
      | false        | 1     | false         | 2     | false       | 1     | true           | 2     |# notifica1
      | false        | 1     | false         | 2     | true        | 1     | false          | 2     |# notifica1
      | false        | 1     | true          | 2     | false       | 1     | false          | 2     |# notifica1
      | false        | 1     | false         | 2     | true        | 1     | true           | 2     |# notifica2
      | false        | 1     | true          | 2     | false       | 1     | true           | 2     |# notifica2
      | false        | 1     | true          | 2     | true        | 1     | false          | 2     |# notifica2
      | false        | 1     | true          | 2     | true        | 1     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-20---W-16-------
      | true         | 1     | true          | 2     | true        | 2     | true           | 2     |# notifica4
      | true         | 1     | true          | 2     | true        | 2     | false          | 2     |# notifica3
      | true         | 1     | true          | 2     | false       | 2     | true           | 2     |# notifica4
      | true         | 1     | false         | 2     | true        | 2     | true           | 2     |# notifica3
      | true         | 1     | true          | 2     | false       | 2     | false          | 2     |# notifica3
      | true         | 1     | false         | 2     | true        | 2     | false          | 2     |# notifica2
      | true         | 1     | false         | 2     | false       | 2     | true           | 2     |# notifica3
      | true         | 1     | false         | 2     | false       | 2     | false          | 2     |# notifica2
      | false        | 1     | false         | 2     | false       | 2     | false          | 2     |
      | false        | 1     | false         | 2     | false       | 2     | true           | 2     |# notifica1
      | false        | 1     | false         | 2     | true        | 2     | false          | 2     |# notifica1
      | false        | 1     | true          | 2     | false       | 2     | false          | 2     |# notifica1
      | false        | 1     | false         | 2     | true        | 2     | true           | 2     |# notifica2
      | false        | 1     | true          | 2     | false       | 2     | true           | 2     |# notifica2
      | false        | 1     | true          | 2     | true        | 2     | false          | 2     |# notifica2
      | false        | 1     | true          | 2     | true        | 2     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-8---W-28------------------------------------------
      | true         | 2     | true          | 1     | true        | 1     | true           | 1     |# notifica4
      | true         | 2     | true          | 1     | true        | 1     | false          | 1     |# notifica3
      | true         | 2     | true          | 1     | false       | 1     | true           | 1     |# notifica4
      | true         | 2     | false         | 1     | true        | 1     | true           | 1     |# notifica3
      | true         | 2     | true          | 1     | false       | 1     | false          | 1     |# notifica3
      | true         | 2     | false         | 1     | true        | 1     | false          | 1     |# notifica2
      | true         | 2     | false         | 1     | false       | 1     | true           | 1     |# notifica3
      | true         | 2     | false         | 1     | false       | 1     | false          | 1     |# notifica2
      | false        | 2     | false         | 1     | false       | 1     | false          | 1     |
      | false        | 2     | false         | 1     | false       | 1     | true           | 1     |# notifica1
      | false        | 2     | false         | 1     | true        | 1     | false          | 1     |# notifica1
      | false        | 2     | true          | 1     | false       | 1     | false          | 1     |# notifica1
      | false        | 2     | false         | 1     | true        | 1     | true           | 1     |# notifica2
      | false        | 2     | true          | 1     | false       | 1     | true           | 1     |# notifica2
      | false        | 2     | true          | 1     | true        | 1     | false          | 1     |# notifica2
      | false        | 2     | true          | 1     | true        | 1     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-28---W-8-------
      | true         | 2     | true          | 1     | true        | 1     | true           | 2     |# notifica4
      | true         | 2     | true          | 1     | true        | 1     | false          | 2     |# notifica3
      | true         | 2     | true          | 1     | false       | 1     | true           | 2     |# notifica4
      | true         | 2     | false         | 1     | true        | 1     | true           | 2     |# notifica3
      | true         | 2     | true          | 1     | false       | 1     | false          | 2     |# notifica3
      | true         | 2     | false         | 1     | true        | 1     | false          | 2     |# notifica2
      | true         | 2     | false         | 1     | false       | 1     | true           | 2     |# notifica3
      | true         | 2     | false         | 1     | false       | 1     | false          | 2     |# notifica2
      | false        | 2     | false         | 1     | false       | 1     | false          | 2     |
      | false        | 2     | false         | 1     | false       | 1     | true           | 2     |# notifica1
      | false        | 2     | false         | 1     | true        | 1     | false          | 2     |# notifica1
      | false        | 2     | true          | 1     | false       | 1     | false          | 2     |# notifica1
      | false        | 2     | false         | 1     | true        | 1     | true           | 2     |# notifica2
      | false        | 2     | true          | 1     | false       | 1     | true           | 2     |# notifica2
      | false        | 2     | true          | 1     | true        | 1     | false          | 2     |# notifica2
      | false        | 2     | true          | 1     | true        | 1     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-20---W-16-------
      | true         | 2     | true          | 1     | true        | 2     | true           | 1     |# notifica4
      | true         | 2     | true          | 1     | true        | 2     | false          | 1     |# notifica3
      | true         | 2     | true          | 1     | false       | 2     | true           | 1     |# notifica4
      | true         | 2     | false         | 1     | true        | 2     | true           | 1     |# notifica3
      | true         | 2     | true          | 1     | false       | 2     | false          | 1     |# notifica3
      | true         | 2     | false         | 1     | true        | 2     | false          | 1     |# notifica2
      | true         | 2     | false         | 1     | false       | 2     | true           | 1     |# notifica3
      | true         | 2     | false         | 1     | false       | 2     | false          | 1     |# notifica2
      | false        | 2     | false         | 1     | false       | 2     | false          | 1     |
      | false        | 2     | false         | 1     | false       | 2     | true           | 1     |# notifica1
      | false        | 2     | false         | 1     | true        | 2     | false          | 1     |# notifica1
      | false        | 2     | true          | 1     | false       | 2     | false          | 1     |# notifica1
      | false        | 2     | false         | 1     | true        | 2     | true           | 1     |# notifica2
      | false        | 2     | true          | 1     | false       | 2     | true           | 1     |# notifica2
      | false        | 2     | true          | 1     | true        | 2     | false          | 1     |# notifica2
      | false        | 2     | true          | 1     | true        | 2     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-16--W-20--------
      | true         | 2     | true          | 2     | true        | 1     | true           | 1     |# notifica4
      | true         | 2     | true          | 2     | true        | 1     | false          | 1     |# notifica3
      | true         | 2     | true          | 2     | false       | 1     | true           | 1     |# notifica4
      | true         | 2     | false         | 2     | true        | 1     | true           | 1     |# notifica3
      | true         | 2     | true          | 2     | false       | 1     | false          | 1     |# notifica3
      | true         | 2     | false         | 2     | true        | 1     | false          | 1     |# notifica2
      | true         | 2     | false         | 2     | false       | 1     | true           | 1     |# notifica3
      | true         | 2     | false         | 2     | false       | 1     | false          | 1     |# notifica2
      | false        | 2     | false         | 2     | false       | 1     | false          | 1     |
      | false        | 2     | false         | 2     | false       | 1     | true           | 1     |# notifica1
      | false        | 2     | false         | 2     | true        | 1     | false          | 1     |# notifica1
      | false        | 2     | true          | 2     | false       | 1     | false          | 1     |# notifica1
      | false        | 2     | false         | 2     | true        | 1     | true           | 1     |# notifica2
      | false        | 2     | true          | 2     | false       | 1     | true           | 1     |# notifica2
      | false        | 2     | true          | 2     | true        | 1     | false          | 1     |# notifica2
      | false        | 2     | true          | 2     | true        | 1     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-20-----W-16-----
      | true         | 2     | true          | 1     | true        | 2     | true           | 2     |# notifica4
      | true         | 2     | true          | 1     | true        | 2     | false          | 2     |# notifica3
      | true         | 2     | true          | 1     | false       | 2     | true           | 2     |# notifica4
      | true         | 2     | false         | 1     | true        | 2     | true           | 2     |# notifica3
      | true         | 2     | true          | 1     | false       | 2     | false          | 2     |# notifica3
      | true         | 2     | false         | 1     | true        | 2     | false          | 2     |# notifica2
      | true         | 2     | false         | 1     | false       | 2     | true           | 2     |# notifica3
      | true         | 2     | false         | 1     | false       | 2     | false          | 2     |# notifica2
      | false        | 2     | false         | 1     | false       | 2     | false          | 2     |
      | false        | 2     | false         | 1     | false       | 2     | true           | 2     |# notifica1
      | false        | 2     | false         | 1     | true        | 2     | false          | 2     |# notifica1
      | false        | 2     | true          | 1     | false       | 2     | false          | 2     |# notifica1
      | false        | 2     | false         | 1     | true        | 2     | true           | 2     |# notifica2
      | false        | 2     | true          | 1     | false       | 2     | true           | 2     |# notifica2
      | false        | 2     | true          | 1     | true        | 2     | false          | 2     |# notifica2
      | false        | 2     | true          | 1     | true        | 2     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-8---W-28-------
      | true         | 2     | true          | 2     | true        | 2     | true           | 1     |# notifica4
      | true         | 2     | true          | 2     | true        | 2     | false          | 1     |# notifica3
      | true         | 2     | true          | 2     | false       | 2     | true           | 1     |# notifica4
      | true         | 2     | false         | 2     | true        | 2     | true           | 1     |# notifica3
      | true         | 2     | true          | 2     | false       | 2     | false          | 1     |# notifica3
      | true         | 2     | false         | 2     | true        | 2     | false          | 1     |# notifica2
      | true         | 2     | false         | 2     | false       | 2     | true           | 1     |# notifica3
      | true         | 2     | false         | 2     | false       | 2     | false          | 1     |# notifica2
      | false        | 2     | false         | 2     | false       | 2     | false          | 1     |
      | false        | 2     | false         | 2     | false       | 2     | true           | 1     |# notifica1
      | false        | 2     | false         | 2     | true        | 2     | false          | 1     |# notifica1
      | false        | 2     | true          | 2     | false       | 2     | false          | 1     |# notifica1
      | false        | 2     | false         | 2     | true        | 2     | true           | 1     |# notifica2
      | false        | 2     | true          | 2     | false       | 2     | true           | 1     |# notifica2
      | false        | 2     | true          | 2     | true        | 2     | false          | 1     |# notifica2
      | false        | 2     | true          | 2     | true        | 2     | true           | 1     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-8---W-28-------
      | true         | 2     | true          | 2     | true        | 1     | true           | 2     |# notifica4
      | true         | 2     | true          | 2     | true        | 1     | false          | 2     |# notifica3
      | true         | 2     | true          | 2     | false       | 1     | true           | 2     |# notifica4
      | true         | 2     | false         | 2     | true        | 1     | true           | 2     |# notifica3
      | true         | 2     | true          | 2     | false       | 1     | false          | 2     |# notifica3
      | true         | 2     | false         | 2     | true        | 1     | false          | 2     |# notifica2
      | true         | 2     | false         | 2     | false       | 1     | true           | 2     |# notifica3
      | true         | 2     | false         | 2     | false       | 1     | false          | 2     |# notifica2
      | false        | 2     | false         | 2     | false       | 1     | false          | 2     |
      | false        | 2     | false         | 2     | false       | 1     | true           | 2     |# notifica1
      | false        | 2     | false         | 2     | true        | 1     | false          | 2     |# notifica1
      | false        | 2     | true          | 2     | false       | 1     | false          | 2     |# notifica1
      | false        | 2     | false         | 2     | true        | 1     | true           | 2     |# notifica2
      | false        | 2     | true          | 2     | false       | 1     | true           | 2     |# notifica2
      | false        | 2     | true          | 2     | true        | 1     | false          | 2     |# notifica2
      | false        | 2     | true          | 2     | true        | 1     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-12---W-24-------
      | true         | 2     | true          | 2     | true        | 2     | true           | 2     |# notifica4
      | true         | 2     | true          | 2     | true        | 2     | false          | 2     |# notifica3
      | true         | 2     | true          | 2     | false       | 2     | true           | 2     |# notifica4
      | true         | 2     | false         | 2     | true        | 2     | true           | 2     |# notifica3
      | true         | 2     | true          | 2     | false       | 2     | false          | 2     |# notifica3
      | true         | 2     | false         | 2     | true        | 2     | false          | 2     |# notifica2
      | true         | 2     | false         | 2     | false       | 2     | true           | 2     |# notifica3
      | true         | 2     | false         | 2     | false       | 2     | false          | 2     |# notifica2
      | false        | 2     | false         | 2     | false       | 2     | false          | 2     |
      | false        | 2     | false         | 2     | false       | 2     | true           | 2     |# notifica1
      | false        | 2     | false         | 2     | true        | 2     | false          | 2     |# notifica1
      | false        | 2     | true          | 2     | false       | 2     | false          | 2     |# notifica1
      | false        | 2     | false         | 2     | true        | 2     | true           | 2     |# notifica2
      | false        | 2     | true          | 2     | false       | 2     | true           | 2     |# notifica2
      | false        | 2     | true          | 2     | true        | 2     | false          | 2     |# notifica2
      | false        | 2     | true          | 2     | true        | 2     | true           | 2     |# notifica3
# ------------------------------------------------------------------------------------------------------------------SMS-0---W-36-------
