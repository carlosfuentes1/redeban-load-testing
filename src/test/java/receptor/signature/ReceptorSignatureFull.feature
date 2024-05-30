Feature: Ejecutar Endpoint para crear una transaccion aprobada y validando distintos datos de respuesta

  Background:
    * def bodyTrxCorr = read('classpath:helpersCorr/signature/BodySignatureFull.json')
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
    And request bodyTrxCorr.payload[0].signature.signature = <signature>
    And request bodyTrxCorr
    When method post
    Then status 200
    * eval sleep(01)
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.responseCode == '00'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | signatureFlag            | signature            |
      | 0123456789               | 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 7984415487416546545123165456                                                                     | # solo numéricos
      | QWERtyJD                 | abcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefskjdhdgshfjhgjfklbjfkdjhgalkfsa{ñdlsañfadgjiotjrk,b mxknvgkdfjhjlkzhlñhkhdtlñhgngfñ                                                                     | # solo texto
      | @!!"#$%&                 | -@!$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()_-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&()-+=~[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()-+=[]{};:'"<>,.?/\!@#$%^&*()_-+=~[]{};:'"<>,.?/!@#$%^&*()_-+=`[]{}/**/*-/*-                                                                                                                        | # solo caracteres especiales
      | 123@$%COD                | qR7W9hNz0E1uR2yTjXv8SbZdPcMfK3qL7aVhYnW5dFjZgTpQ4yU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5vThYnWgTp4QyU6iVxW9vS1qR2uNz0EaRbZd3PcMfjX5v                                                                  | # solo alfanuméricos
      |                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | # solo nulos
      | ""                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | # solo vacíos
      | falsee                   | 424D3E0F(12)3E(6)28(6)2C01(4)6(8)10001(56)B1{6}01{75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){41}E0{32}(5){40}8000{31}(5){39}000E01{30}(5){37}C003FFE01{29}(5){36}E007{4}C01{28}(5){36}C1{7}C03{27}(5){36}8{9}C07{26}(5){36}9{10}80{26}(5){36}9{11}01{25}(5){36}9{11}E03{24}(5){36}1{12}C07{23}(5){36}3{13}80{23}(5){35}E3{14}01{22}(5){35}E7{14}E03{21}(5){35}C7{15}C03{20}(5){35}C{17}807{19}(5){35}C{18}80{19}(5){35}C{19}00{18}(5){35}C{19}E03{17}(5){35}8{20}E3{17}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{17}3{21}(5){35}9{17}3{21}(5){35}9{16}E3{21}(5){35}8{16}E7{21}(5){35}C{16}C7{21}(5){35}C{16}8{22}(5){35}C{16}9{22}(5){35}C{16}1{22}(5){35}C{16}3{22}(5){35}C{15}E3{22}(5){35}C{15}E7{22}(5){35}C7{14}C7{22}(5){35}E7FFF03{9}C{23}(5){35}E7F0003{9}8{23}(5){34}E(5)7{10}1{23}(5){30}C(7)7{11}E3{23}(5){27}E(7)F3{13}E7{23}(5){26}80001{5}3{13}C7{23}(5){25}000{8}3{13}C{24}(5){10}9{12}E003{9}1{13}C{24}(5){10}9{11}8007{10}9{13}8{24}(5){10}8{10}000{12}9{12}E1{24}(5){10}C{8}E003{13}  | # tamaño desborde
      | fal se                   | 424D3E0F(12)3E(6)28(6)2C01(4)6(8)10001(56)B1{6}01{75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){41}E0{32}(5){40}8000{31}(5){39}000E01{30}(5){37}C003FFE01{29}(5){36}E007{4}C01{28}(5){36}C1{7}C03{27}(5){36}8{9}C07{26}(5){36}9{10}80{26}(5){36}9{11}01{25}(5){36}9{11}E03{24}(5){36}1{12}C07{23}(5){36}3{13}80{23}(5){35}E3{14}01{22}(5){35}E7{14}E03{21}(5){35}C7{15}C03{20}(5){35}C{17}807{19}(5){35}C{18}80{19}(5){35}C{19}00{18}(5){35}C{19}E03{17}(5){35}8{20}E3{17}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5) {35}9{39}(5){35}9{17}3 {21}(5){35}9{17}3{21}(5){35}9{16}E3{21}(5){35}8{16}E7{21}(5){35}C{16}C7{21}(5){35}C{16}8{22}(5){35}C{16}9{22}(5){35}C{16}1{22}(5){35}C{16}3{22}(5){35}C{15}E3{22}(5){35}C{15}E7{22}(5){35}C7{14}C7{22}(5){35}E7FFF03{9}C{23}(5){35}E7F0003{9}8{23}(5){34}E (5)7{10}1{23}(5){30}C(7)7{11}E3{23}(5){27}E(7)F3{13}E7{23}(5){26}80001{5}3{13}C7{23}(5){25}000{8}3{13}C{24}(5){10}9{12}E003{9}1{13}C{24}(5){10}9{11}8007{10}9{13} 8{24}(5){10}8{10}000{12}9{12}E1{24}(5){10}          | # Correctos standard con espacios
      | true                     | 424D3E0F(12)3E(6)28(6)2C01(4)6(8)10001(56)B1{6}01{75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){75}(5){41}E0{32}(5){40}8000{31}(5){39}000E01{30}(5){37}C003FFE01{29}(5){36}E007{4}C01{28}(5){36}C1{7}C03{27}(5){36}8{9}C07{26}(5){36}9{10}80{26}(5){36}9{11}01{25}(5){36}9{11}E03{24}(5){36}1{12}C07{23}(5){36}3{13}80{23}(5){35}E3{14}01{22}(5){35}E7{14}E03{21}(5){35}C7{15}C03{20}(5){35}C{17}807{19}(5){35}C{18}80{19}(5){35}C{19}00{18}(5){35}C{19}E03{17}(5){35}8{20}E3{17}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{39}(5){35}9{17}3{21}(5){35}9{17}3{21}(5){35}9{16}E3{21}(5){35}8{16}E7{21}(5){35}C{16}C7{21}(5){35}C{16}8{22}(5){35}C{16}9{22}(5){35}C{16}1{22}(5){35}C{16}3{22}(5){35}C{15}E3{22}(5){35}C{15}E7{22}(5){35}C7{14}C7{22}(5){35}E7FFF03{9}C{23}(5){35}E7F0003{9}8{23}(5){34}E(5)7{10}1{23}(5){30}C(7)7{11}E3{23}(5){27}E(7)F3{13}E7{23}(5){26}80001{5}3{13}C7{23}(5){25}000{8}3{13}C{24}(5){10}9{12}E003{9}1{13}C{24}(5){10}9{11}8007{10}9{13}8{24}(5){10}8{10}000{12}9{12}E1{24}(5){10}C{8}00        | # Correctos límite máximo
      | false                    | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | # Correctos límite mínimo
      | true                     | 424D560C(12)3E(6)28(6)1A01(4)56(7)10001(10)180C(36){6}(40)FC(70)7E(70)7E(70)3F(70)1F8(70)FC(70)7E(70)3F(70)3F(70)1F8(70)FC(70)FC(70)7E(70)3F(70)3F(70)1F8(70)7C(70)7C(70)3E(70)1F(70)1F(71)F8(70)F8(70)7C(70)3E(70)3E(70)1F(48)4(22)F8(47)7(22)F8(47)78(21)7C(47)7E(21)7C(47)7F(21)3E(47)3FC(20)3E(47)1FF(20)1F(48)FFC(19)1F(48)7FF(20)F8(47)1FFC(19)F8(48)3FF(19)7C(49)FFC(18)7C(49)3FF(18)3E(50)FFE(17)3E(50)3FFC(16)1F(51)FFF(16)1F(51)3FFE(16)F8(51)FFFC(15)F8(51)1FFF8(14)7C(52)3FFF(14)7C(53)FFFE(13)3E(53)1FFFE(12)3E(54)3{4}8(10)1F(55)7{4}C(9)1F(56){5}8(9)F8(55)1{4}E(9)F8(56)1{4}C(8)7C(58)7FFF8(7)7C(59)3FFF(7)7C(60)7FFF(6)3E(60)1FFFE(5)3E(61)3FFF8(4)1F(62)7FFE(4)1F(63)FFF80001F(64)FFF(4)F8(63)1FFC000F8(64)7FF000F8(64)1FFE00F8(65)7FFC07C(66)FFF87C(66)3FFF7C(67){4}C(67)1FFFC(68)3FF8(69)7E(71)E(968)                                                                                                                                                                                                                       | # Correctos standard