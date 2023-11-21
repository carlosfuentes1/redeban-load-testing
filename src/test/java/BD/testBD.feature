Feature:test bd

  Background: connect BD
    * def connectBD = Java.type('helper.BDHandler')

  Scenario: consultar un registro en la BD
    * def level = connectBD.getData("1")
    * print level.correo
    * print level.password
