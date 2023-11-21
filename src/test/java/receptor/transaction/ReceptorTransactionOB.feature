Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helper/transaction/BodyTransactionOB.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].transaction.approvalNum = <approvalNum>
    And request bodyTrxCorr.payload[0].transaction.responseCode = <responseCode>
    And request bodyTrxCorr.payload[0].transaction.status = <status>
    And request bodyTrxCorr.payload[0].transaction.date = <date>
    And request bodyTrxCorr.payload[0].transaction.hour = <hour>
    And request bodyTrxCorr.payload[0].transaction.authMode = <authMode>
    And request bodyTrxCorr.payload[0].transaction.inMode = <inMode>
    And request bodyTrxCorr.payload[0].transaction.receipt = <receipt>
    And request bodyTrxCorr.payload[0].transaction.rrn = <rrn>
    And request bodyTrxCorr.payload[0].transaction.dateTime = <dateTime>
    And request bodyTrxCorr.payload[0].transaction.transactionType = <transactionType>
    And request bodyTrxCorr
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | approvalNum | responseCode | status | date      | hour  | authMode | inMode | receipt | rrn     | dateTime         | transactionType                   |
      #| 345678      | 01           | 34     | 12345678   | 1234    | 15     | 345    | 123456    | 789012   | 123456789012345 | 12345678901234  | # solo numéricos OK
      #| QERtJD      | JD           | Rt     | QWERtyJD   | QWER  | io       | peh    | urvxma    | qweras   | irtvcjatepmvbck   | CAMBIO DE CLAVE | # solo texto OK
      #| @!"$%&      | @!           | %&     | @*!"#$%&   | @!!"  | /-       | *-/    | $?(!/+    | !"#/()   | =!)"($#%&:;[/-_   | &"$$"/&(/(% | # solo caracteres especiales OK
      #| G8F6D1      | 7W           | %C     | O6P2L4H9   | 1@CO     | 9t    | 7uw    | H4N0Q2    | D0X6V1   | J0K1L2M3N4O5P6 | CAMBIO DE CLAVE |# solo alfanuméricos OK
      #| null        | null         | null   | null       | null  | null     | null   | null      | null     | null             | null                              |# solo nulos--------OK----      # solo vacíos OK
      #| ""          | ""           | ""     | ""   | ""   | ""       | ""     | ""      | ""  | ""         |  ""            |
      #| 'Q6L4K0N'     | 198          | 123    | 123456789 | 06254 | 237      | 7545   | 3408561 | 1234567 | 2023011523456257 | 'Exchange02Transaction123456789012' | #tamaño desborde -----OK-----
      #| 'H13 E5'    | ' 3'          | '0 '    | '222 1111' | '1 25' | '1 '      | '6 4'   | '97 123' | '89 023' | '2023 06 03062890' | 'PAGO FACT. CÓD BARRAS' | # Correctos standard con espacios OK
      #| 'U4O7I5'      | 23           | '02'     | 20230915 | '0716'    | 87       | 571    | 543210  | 345678 | '20230918094100' | 'TRANSFERENCIA CORRIENTE' | # Correctos límite máximo  ---bug-----
      # | A           | 89           | 05     | 20230915 | 1840 | 12       | 9      | 3       | 5   | 202309292345678 | RETIRO NEQUI    | # Correctos límite mínimo
      #--| I8O0R4      | 88           | 85     | 20230915 | 1715 | 09       | 521    | 234567  | 432109 | 20230915122700 | TRANSFERENCIA AHORRO |