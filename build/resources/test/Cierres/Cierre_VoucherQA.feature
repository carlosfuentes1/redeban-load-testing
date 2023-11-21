Feature: Ejecutar Endpoint para realizar el cierre Correcto de una terminal o Datafono

  Background:
    * def path = '/transactional/api/vouchers/closures'
    * def bodyTrx = read('classpath:payloads/BodyCierres.json')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrx.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrx.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrx.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que envia el cierre Correcto de una determinada terminal o datafono
    Given url url
    And path path
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].commerce.financialCode = '<financialCode>'
    And request bodyTrx.payload[0].commerce.address = <address>
    And request bodyTrx.payload[0].commerce.correspondentId = '32692899'
    And request bodyTrx.payload[0].commerce.terminalId = '<terminal>'
    And request bodyTrx
    When method post
    Then status 200
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.status[0].statusCode == '00'
    Examples:
      | financialCode | address                                     | terminal   |
      | 0001          | 'Calle Correcto - TTTTT -WWWW -eeeee ttttt' | AMERICANIN |
#      | 0002          | 'Calle ttttt'                               | AMERICANIN |
#      | 0007          | 'Calle Correcto - TTTTT -WWWW -eeeee ttttt' | AMERICANIN |
#      | 0013          | 'Calle ttttt'                               | AMERICANIN |
#      | 0023          | 'Calle Correcto - TTTTT -WWWW -eeeee ttttt' | AMERICANIN |
#      | 0051          | 'Calle ttttt'                               | AMERICANIN |
#      | 0052          | 'Calle Correcto - TTTTT -WWWW -eeeee ttttt' | AMERICANIN |
#      | 0903          | 'Calle ttttt'                               | AMERICANIN |
#      | 6666          | 'Calle Correcto - TTTTT -WWWW -eeeee ttttt' | AMERICANIN |
      #| 2222          |
      #| 3333          |
      #| 4444          |
      #| 5555          |
      #| 6666          |
      #| 7777          |
      #| 8888          |
      #| 0007          |
      #| 0013          |
      #| 0903          |
      #| 0052          |
      #| 0002          |
      #| 0023          |
      #| 0051          |
      #| 0001          |