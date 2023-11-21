Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/payment/BodyPaymentOB.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia
    * def numeroNormal = dataGenerator.RandomNumber(10,1)
    * def numeroNegativo = dataGenerator.RandomNumber(9,0)
    * def numeroMayor = dataGenerator.RandomNumber(13,1)
    * def numeroMinimo = dataGenerator.RandomNumber(1,1)
    * def numeroMaximo = dataGenerator.RandomNumber(12,1)

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].payment.taxBase = <taxBase>
    And request bodyTrxCorr.payload[0].payment.incAmount = <incAmount>
    And request bodyTrxCorr.payload[0].payment.ivaAmount = <ivaAmount>
    And request bodyTrxCorr.payload[0].payment.tipAmount = <tipAmount>
    And request bodyTrxCorr.payload[0].payment.fullAmount = <fullAmount>
    And request bodyTrxCorr
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | taxBase        | incAmount      | ivaAmount      | tipAmount      | fullAmount     |
      #| 'ASYTEpjtvWUD' | 'ASYTEpjtvWUD' | 'ASYTEpjtvWUD' | 'ASYTEpjtvWUD' | 'ASYTEpjtvWUD' | # solo texto
      #| '@!)$&&/&#$%&' | '@!*-%&)"#$%&' | '@!!"#$%&/*-.' | '/*=&&!"#$%&'  | '!@#$%^&*()_-' | # solo caracteres especiales
      #| '123Z6A1$%COD' | '4E5F6G8S92T0' | 'Q7R8S9T0U1V'  | 'J0K1L2M3N4O'  | '1@QRstu56789' | # solo alfanuméricos
      | null           | null           | null           | null           | null           | # solo nulos
      #| ''             | ''             | ''             | ''             | ''             | # solo vacíos -----BUG no valida confirmar si deberia validar los ccampos vacio
      #| '34561 234567' | '456789 01234' | '24681357 902' | '12345 678900' | '9998 8877766' | # con espacios
      #| numeroNegativo | numeroNegativo | numeroNegativo | numeroNegativo | numeroNegativo | # Negativo
      #| numeroMayor    | numeroMayor    | numeroMayor    | numeroMayor    | numeroMayor    | # superior
      #| numeroMinimo   | numeroMinimo   | numeroMinimo   | numeroMinimo   | numeroMinimo   | # mínimo
      #| numeroMaximo   | numeroMaximo   | numeroMaximo   | numeroMaximo   | numeroMaximo   | # maximo
      #| numeroNormal   | numeroNormal   | numeroNormal   | numeroNormal   | numeroNormal   | # Normal bien