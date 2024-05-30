Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helpersCorr/commerce/BodyScriptOB.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helpersCorr.DataGenerator')
    * set bodyTrxCorr.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrxCorr.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helpersCorr/dateTime.js')
    * set bodyTrxCorr.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrxCorr.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrxCorr.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion con firma
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrxCorr.payload[0].commerce.script = <script>
    And request bodyTrxCorr
    When method post
    Then status 200
    * eval sleep(01)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.responseCode == '00'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | script                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890                                                                                                   | # solo numéricos
      | abcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefskjdhdgshfjhgjfklbjfkdjhgalkfsa                                                                                                                          | # solo texto
      | -@!$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()_-+=`[]{}/**/*-/*-                                                                                                                         | # solo caracteres especiales
      | qR7W9hNz0E1uR2yTjXv8SbZdPcMfK3qL7aVhYnW5dFjZgTpQ4yU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5v                                                                   | # solo alfanuméricos
      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | # solo nulos
      | ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | # solo vacíos
      | [0X0A][0X1C][0X2A][0X3A]prueba aleatoria sobre el script monica alejandra largo ffjyijytityijjfheghdhgkdfjhgjdfkhgdfjhñlkph68+86568+9659+kngdfkjhgerjhodfhbjndkfjbgsofñhjkfljfslkdndkgfhjodjhdfklhkfdl165486544548621jhfdljhfdlkjhbksfhgsfhgsjhgsfkjhgsfjhgfsg [0X0A][0X1C][0X2A][0X3A]dirección largo para la prueba Calle 12 numero  212 - 212 bis tercer piso apartamento 6 [0X0A][0X1A][0X2A][0X3A] C.ÚNICO: 348529468742165749851654 [0X1B] TER: TERMI89549844156468454658745487854 [0X0A][0X1A][0X2A][0X3A] CAJA C.F.BC CUO: 02  [0X0A][0X1A]105933566519876 [0X1C] RECIBO: 6502346544546421564654 [0X1B] RRN: 00007579863526560023 [0X0A][0X1C][0X2A][0X3B] ARQC: 7B4DE3Dkflhuw98e5723oijfdtiu45675456787544534958C57FD08D2[0X0A][0X1C]AID: AAA00000010003[0X0A][0X1C]AP LABEL: REDEBAN MB[0X0A][0X1A]VENTA[0X1B]APRO: fhiewhfsdfsdhjgugh [0X0A][0X1A]COMPRA NETA[0X1B]$ 300.000.000[0X0A][0X1A]IVA[0X1B]$ 100.000.000[0X0A][0X1A]INC[0X1B]$ 100.000.000[0X0A][0X1A]PROPINA[0X1B]$ 100.000.000[0X0A][0X1A][0X3C]TOTAL[0X1B]$ 100.000.000  | # tamaño desborde
      | [0X0A][0X1C][0X2A][0X3A]prueba aleatoria sobre el script monica alejandra largo ffjyijytityijjfheghdhgkdfjhgjdfkhgdfjkngdfkjhgerjhodfhbjndkfjbgsofñhjkfljfslkdndkgfhjodjhdfklhkfdljhfdljhfdlkjhbksfhgsfhgsjhgsfkjhgsfjhgfsg [0X0A][0X1C][0X2A][0X3A]dirección largo para la prueba Calle 12 numero  212 - 212 bis tercer piso apartamento 6 [0X0A][0X1A][0X2A][0X3A] C.ÚNICO: 348529468742165749851654 [0X1B] TER: TERMI895498445487854 [0X0A][0X1A][0X2A][0X3A] CAJA C.F.BC CUO: 02  [0X0A][0X1A]105933566519876 [0X1C] RECIBO: 6502346544546421564654 [0X1B] RRN: 00007579863526560023 [0X0A][0X1C][0X2A][0X3B] ARQC: 7B4DE3Dkflhuw98e5723oijfdtiu34958C57FD08D2[0X0A][0X1C]AID: AAA00000010003[0X0A][0X1C]AP LABEL: REDEBAN MB[0X0A][0X1A]VENTA[0X1B]APRO: fhiewhfsdfsdhjgugh [0X0A][0X1A]COMPRA NETA[0X1B]$ 300.000.000[0X0A][0X1A]IVA[0X1B]$ 100.000.000[0X0A][0X1A]INC[0X1B]$ 100.000.000[0X0A][0X1A]PROPINA[0X1B]$ 100.000.000[0X0A][0X1A][0X3C]TOTAL[0X1B]$ 100.000.000                                                                  | # Correctos standard con espacios
      | [0X0A][0X1C][0X2A][0X3A]prueba aleatoria sobre el script monica alejandra largo ffjyijytityijjfheghdhgkdfjhgjdfkhgdfjhñlkph68+86568+9659+kngdfkjhgerjhodfhbjndkfjbgsofñhjkfljfslkdndkgfhjodjhdfklhkfdl165486544548621jhfdljhfdlkjhbksfhgsfhgsjhgsfkjhgsfjhgfsg [0X0A][0X1C][0X2A][0X3A]dirección largo para la prueba Calle 12 numero  212 - 212 bis tercer piso apartamento 6 [0X0A][0X1A][0X2A][0X3A] C.ÚNICO: 348529468742165749851654 [0X1B] TER: TERMI89549844156468454658745487854 [0X0A][0X1A][0X2A][0X3A] CAJA C.F.BC CUO: 02  [0X0A][0X1A]105933566519876 [0X1C] RECIBO: 6502346544546421564654 [0X1B] RRN: 0003526560023 [0X0A][0X1C][0X2A][0X3B] ARQC: 7B4DE3Dkflhuw98e5723oijfdtiu45675456787544534958C57FD08D2[0X0A][0X1C]AID: AAA00000010003[0X0A][0X1C]AP LABEL: REDEBAN MB[0X0A][0X1A]VENTA[0X1B]APRO: fhiewhfsdfsdhjgugh [0X0A][0X1A]COMPRA NETA[0X1B]$ 300.000.000[0X0A][0X1A]IVA[0X1B]$ 100.000.000[0X0A][0X1A]INC[0X1B]$ 100.000.000[0X0A][0X1A]PROPINA[0X1B]$ 100.000.000[0X0A][0X1A][0X3C]TOTAL[0X1B]$ 100.000.000         | # Correctos límite máximo
      | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | # Correctos límite mínimo
      | [0X0A][0X1C][0X2C][0X3B]PRUEBAS PCO           [0X0A][0X1C][0X2C][0X3B]CR 20 33 - 15         [0X0A]    [0X1A][0X2A][0X3A]C.UNICO:0010203040 [0X1B]TER:LEAL0001[0X0A][0X1A]ID CAJERO:     00000[0X0A][0X1C]RECIBO:000087[0X0A][0X1C]Documento:1793****00[0X0A][0X1C]CARLOS AUGUS[0X0A][0X2A][0X1A]ACUMULACION[0X1B]APRO:000000[0X0A][0X2B][0X3C][0X1A]VALOR[0X1B] $  67.830[0X0A][0X2B][0X1A][0X3A]P.ACUM[0X1B]  133[0X0A][0X2B][0X1A]T.PUNTOS[0X1B] 000000013443[0X0A][0X0A][0X0A][0X2A][0X1A]INGRESA A WWW.PUNTOSCOLOMBIA.COM Y DISFRUTA DE LOS BENEFICIOS QUE TENEMOS PARA TI[0X0A][0X0A][0X0A][0X2A][0X1C]PUNTOS COLOMBIA VIVES.GANAS[0X0A]                                                                                                                                                                                                                                                                                                                                                                                                    | # Correctos standard