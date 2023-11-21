Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helpersCorr/paymentMethod/BodyPaymentMethodFull.json')
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
    And request bodyTrxCorr.payload[0].paymentMethod.franchise = <franchise>
    And request bodyTrxCorr.payload[0].paymentMethod.millerNum = <millerNum>
    And request bodyTrxCorr.payload[0].paymentMethod.card = <card>
    And request bodyTrxCorr.payload[0].paymentMethod.accountType = <accountType>
    And request bodyTrxCorr
    When method post
    Then status 200
    * eval sleep(01)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.responseCode == '00'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | franchise             | millerNum                      | card               | accountType  |
      | 7539514682            | 5678901234567890123456789012   | 2589631470975842   | 01           | # solo numéricos
      | wyudsCnvla            | SghIJKLMNoPqRstUVWXYZabcDEF    | tyeiabcDOYRQAXPL   | QW           | # solo texto
      | _-+=*&^%$#            | +*-/_{}[]!@#$%^&()=;><~`       | []{}-+=~`*#$/)#"   | !@           | # solo caracteres especiales
      | 56pQrS7t8U            | Abc123DEf456GhI789JklmNqRst    | 56789iJKLM454413   | S4           | # solo alfanuméricos
      |                       |                                |                    |              | # solo nulos
      | ""                    | ""                             | ""                 | ""           | # solo vacíos
      | 123456789012345y      | IJKLMNOPQR1234WXYZabcDEfGhjyg6 | G@H9I*J&K7L8M9Nfgt | 123          | # tamaño desborde
      | 1098 733994           | XyA12bCDE5 FGhijKoPQRSTUfgh    | X@y6Z7*10 2#34%56  | 0 0          | # Correctos standard con espacios
      | MASTERCARD            | 2345lmnoPqRstUVW678XYZaBCDE9   | A!b2C#d3E$f4G*h5   | CR           | # Correctos límite máximo
      | MASTERCARD            | 0                              | p                  | CC           | # Correctos límite mínimo
      | MASTERCARD            | 12KlMNo345pQRsT6789UVWXYab     | UV7W8X9YZ*12       | AH           | # Correctos standard