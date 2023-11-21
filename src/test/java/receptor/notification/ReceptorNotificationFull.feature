Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/notification/BodynotificationFull.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia
    * def numeroMaximo = dataGenerator.NumberCelular()

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].notification.notificationFlag = <notificationFlag>
    And request bodyTrxCorr.payload[0].notification.cellphone = <cellphone>
    And request bodyTrxCorr.payload[0].notification.notificationType = <notificationType>
    And request bodyTrxCorr
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | notificationFlag | cellphone  | notificationType |
      #| 45              | 1516584512   | 9                | # solo numéricos
      #| "Rt"             | "tyJDyullnt" | "t"              | # solo texto
      #| '%&'             | '%&/*-*!$%&)' | '%'              | # solo caracteres especiales
      #| '3@%C'           | '3@%Catb8' | '@'              | # solo alfanuméricos
      #| true             | null      | null             | # solo nulos
      #| ""               | ""           | ""               | # solo vacíos
      #| true             | numeroMaximo | 12               | # tamaño desborde
      #| true             | '32155 67'   | 1                | # Correctos standard con espacios
      #----| true             | 3177928280 | 1                | # Correctos límite máximo BUG [{"code": "B400002", "error": "notification.cellphone : El numero no coincide con un formato telefonico valido."}, {"code": "B400002", "error": "notification.cellphone : size must be between 0 and 10"}]
      #| true            | 3   | 1                | # Correctos límite mínimo
      #| true             | numeroMaximo   | 2                | # Correctos standard