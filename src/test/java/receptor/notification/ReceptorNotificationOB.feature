Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/notification/BodynotificationOB.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].notification.notificationFlag = <notificationFlag>
    And request bodyTrxCorr
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | notificationFlag |
      | 3456789                  | # solo numéricos BUG no valida el tipo numerico no falla, no guarda error en base de datos validar
      #| 'QWERtyJD'       | # solo texto el error no se almacena en la base de datos ¿deberia guardar un error especifico en este caso?
      #| '@!!"#$%&'       | # solo caracteres especiales el error no se almacena en la base de datos ¿deberia guardar un error especifico en este caso?
      #| '123@$%COD'      | # solo alfanuméricos el error no se almacena en la base de datos ¿deberia guardar un error especifico en este caso?
      #| null             | # solo nulos BUG no se valida si es null
      #| ''                       | # solo vacíos BUG no valida valor vacio
      #| true                     | # Correctos límite mínimo ok si va en true valida que exista un número de telefono
      #| false            | # Correctos standard OK