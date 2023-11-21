Feature: Ejecutar Endpoint para crear el token que se usara para crear las transacciones

  Scenario: crear token
    Given url apiToken
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header Authorization = tokenAuthorization
    And request 'grant_type=client_credentials&Scope=consumers%2Ffabrica'
    When method post
    Then status 200
    * def access_token = response.access_token