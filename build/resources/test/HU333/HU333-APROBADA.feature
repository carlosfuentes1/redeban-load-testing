Feature: Ejecutar Endpoint para crear una transaccion aprobada con firma y validando distintos datos de respuesta

  Background:
    * def bodyTrx = read('classpath:payloads/payloadHU333.json ')
    * def responseTimeRange = { min: 10, max: 15000 }
    * def dataGenerator = Java.type('helper.DataGenerator')
    * set bodyTrx.payload[0].transaction.receipt = dataGenerator.getRandomNumReceipt()
    * set bodyTrx.payload[0].payment.fullAmount = dataGenerator.getRandomValueReceipt()
    * def dateTimes = karate.call('classpath:helper/dateTime.js')
    * set bodyTrx.payload[0].transaction.dateTime = dateTimes.date
    * set bodyTrx.payload[0].transaction.hour = dateTimes.hora
    * set bodyTrx.payload[0].transaction.date = dateTimes.dia

  Scenario Outline: peticion Post que obtiene el token de cognito y luego lo pasa al header de la peticion de aprobacion con firma
    * def sleep = function(pause){java.lang.Thread.sleep(pause)}
    Given url url
    And path pathUrl
    And header x-api-key = apiKey
    And request bodyTrx.payload[0].transaction.status = '00'
    And request bodyTrx.payload[0].commerce.financialCode = '<financialCode>'
    And request bodyTrx.payload[0].commerce.correspondentId = '32692899'
    And request bodyTrx.payload[0].commerce.terminalId = 'VOUCHER123'
    And request bodyTrx.payload[0].paymentMethod.franchise = <franchise>
    And request bodyTrx.payload[0].paymentMethod.accountType = <accountType>
    And request bodyTrx.payload[0].transaction.transactionType = '<transactionType>'
    And request bodyTrx.payload[0].transaction.authMode = <authMode>
    And request bodyTrx.payload[0].transaction.inMode = <inMode>
    And request bodyTrx
    When method post
    Then status 200
    And match response.status[0].statusDescription == 'PROCESSED'
    And match response.resultObject[0].transaction.status == '00'
    And assert responseTime >= responseTimeRange.min && responseTime <= responseTimeRange.max
    Examples:
      | franchise      | accountType | inMode | transactionType         | authMode | financialCode |
      | 'AMEX'         | 'AH'        | '00'   | TRANSFERENCIA AHORRO    | '00'     | 2255          |
      | 'BCO_SUP'      | 'CC'        | '01'   | TRANSFERENCIA AHORRO    | '01'     | 2255          |
      | 'DINERSCLUB'   | 'CR'        | '02'   | TRANSFERENCIA AHORRO    | '02'     | 2255          |
#      | 'MAESTRO'      | '00'        | '03'   | TRANSFERENCIA AHORRO    | '03'     | 0052          |
#      | 'CREDENCIAL'   | 'AH'        | '05'   | TRANSFERENCIA CORRIENTE | '04'     | 0002          |
#      | 'MASTERCARD'   | 'CC'        | '07'   | TRANSFERENCIA CORRIENTE | '05'     | 0023          |
#      | 'VISA DEBIT'   | 'CR'        | '80'   | TRANSFERENCIA CORRIENTE | '06'     | 0051          |
#      | 'V.ELECTRON'   | '00'        | '90'   | TRANSFERENCIA CORRIENTE | '07'     | 0001          |
#      | 'CREDITO P'    | 'AH'        | '00'   | TRANSFERENCIA OTRA CTA  | '08'     | 0007          |
#      | 'T. ALKOSTO'   | 'CC'        | '01'   | TRANSFERENCIA OTRA CTA  | '09'     | 0013          |
#      | 'TUYA'         | 'CR'        | '02'   | TRANSFERENCIA OTRA CTA  | '10'     | 0903          |
#      | 'PRIVADACR'    | '00'        | '03'   | TRANSFERENCIA OTRA CTA  | '00'     | 0052          |
#      | 'CREDENVISA'   | 'AH'        | '05'   | RETIRO                  | '01'     | 0002          |
#      | 'COLSUBISIDIO' | 'CC'        | '07'   | RETIRO                  | '02'     | 0023          |
#      | 'CAJA C.F.'    | 'CR'        | '80'   | RETIRO                  | '03'     | 0051          |
#      | 'T. PRIVADA'   | '00'        | '90'   | RETIRO                  | '04'     | 0001          |
#      | 'T. CREDITO'   | 'AH'        | '00'   | AHORRO A LA MANO        | '05'     | 0007          |
#      | 'T. EXITO'     | 'CC'        | '01'   | AHORRO A LA MANO        | '06'     | 0013          |
#      | 'C.M.R'        | 'CR'        | '02'   | AHORRO A LA MANO        | '07'     | 0903          |
#      | 'TARL TCO'     | '00'        | '03'   | AHORRO A LA MANO        | '08'     | 0052          |
#      | 'PRIVADA'      | 'AH'        | '05'   | RETIRO NEQUI            | '09'     | 0002          |
#      | 'CREDITOPR'    | 'CC'        | '07'   | RETIRO NEQUI            | '10'     | 0023          |
#      | 'BONO CODEN'   | 'CR'        | '80'   | RETIRO NEQUI            | '00'     | 0051          |
#      | 'BONOS'        | '00'        | '90'   | RETIRO NEQUI            | '01'     | 0001          |
#      | 'SODEXO'       | 'AH'        | '00'   | RETIRO PAGOS            | '02'     | 0007          |
#      | 'BIG PASS'     | 'CC'        | '01'   | RETIRO PAGOS            | '03'     | 0013          |
#      | 'BTERA.OTP'    | 'CR'        | '02'   | RETIRO PAGOS            | '04'     | 0903          |
#      | 'PTOSCOLMB'    | '00'        | '03'   | RETIRO PAGOS            | '05'     | 0052          |
#      | 'LIFEMILES'    | 'AH'        | '05'   | DEPOSITO AHORROS        | '06'     | 0002          |
#      | 'MASTER DEBI'  | 'CC'        | '80'   | DEPOSITO AHORROS        | '07'     | 0023          |
#      | 'MASTER'       | 'CR'        | '90'   | DEPOSITO AHORROS        | '08'     | 0051          |
#      | 'MASTERD'      | '00'        | '00'   | DEPOSITO AHORROS        | '09'     | 0001          |
#      | 'MASTER DEB'   | 'AH'        | '01'   | DEPOSITO CORRIENTE      | '10'     | 0007          |
#      | 'MASTER DEBIT' | 'CC'        | '02'   | DEPOSITO CORRIENTE      | '00'     | 0013          |
#      | 'VISA'         | 'CR'        | '03'   | DEPOSITO CORRIENTE      | '01'     | 0903          |
#      | 'DINERS'       | '00'        | '05'   | DEPOSITO CORRIENTE      | '02'     | 0052          |
#      | 'AMEX'         | 'AH'        | '07'   | RECARGA NEQUI           | '03'     | 0002          |
#      | 'BCO_SUP'      | 'CC'        | '80'   | RECARGA NEQUI           | '04'     | 0023          |
#      | 'DINERSCLUB'   | 'CR'        | '90'   | RECARGA NEQUI           | '05'     | 0051          |
#      | 'MAESTRO'      | '00'        | '00'   | RECARGA NEQUI           | '06'     | 0001          |
#      | 'CREDENCIAL'   | 'AH'        | '01'   | PAGO FACTURA MANUAL     | '07'     | 0007          |
#      | 'MASTERCARD'   | 'CC'        | '02'   | PAGO FACTURA MANUAL     | '08'     | 0013          |
#      | 'VISA DEBIT'   | 'CR'        | '03'   | PAGO FACTURA MANUAL     | '09'     | 0903          |
#      | 'V.ELECTRON'   | '00'        | '05'   | PAGO FACTURA MANUAL     | '10'     | 0052          |
#      | 'CREDITO P'    | 'AH'        | '07'   | PAGO FACT. CÓD BARRAS   | '00'     | 0002          |
#      | 'T. ALKOSTO'   | 'CC'        | '80'   | PAGO FACT. CÓD BARRAS   | '01'     | 0023          |
#      | 'TUYA'         | 'CR'        | '90'   | PAGO FACT. CÓD BARRAS   | '02'     | 0051          |
#      | 'PRIVADACR'    | '00'        | '00'   | PAGO FACT. CÓD BARRAS   | '03'     | 0001          |
#      | 'CREDENVISA'   | 'AH'        | '01'   | PAGO FACT. TARJ EMPRES  | '04'     | 0007          |
#      | 'COLSUBISIDIO' | 'CC'        | '02'   | PAGO FACT. TARJ EMPRES  | '05'     | 0013          |
#      | 'CAJA C.F.'    | 'CR'        | '03'   | PAGO FACT. TARJ EMPRES  | '06'     | 0903          |
#      | 'T. PRIVADA'   | '00'        | '05'   | PAGO FACT. TARJ EMPRES  | '07'     | 0052          |
#      | 'T. CREDITO'   | 'AH'        | '07'   | PAGO TARJETA DE CRÉDITO | '08'     | 0002          |
#      | 'T. EXITO'     | 'CC'        | '80'   | PAGO TARJETA DE CRÉDITO | '09'     | 0023          |
#      | 'C.M.R'        | 'CR'        | '90'   | PAGO TARJETA DE CRÉDITO | '10'     | 0051          |
#      | 'TARL TCO'     | '00'        | '00'   | PAGO TARJETA DE CRÉDITO | '00'     | 0001          |
#      | 'PRIVADA'      | 'AH'        | '01'   | PAGO CARTERA            | '01'     | 0007          |
#      | 'CREDITOPR'    | 'CC'        | '02'   | PAGO CARTERA            | '02'     | 0013          |
#      | 'BONO CODEN'   | 'CR'        | '03'   | PAGO CARTERA            | '03'     | 0903          |
#      | 'BONOS'        | '00'        | '05'   | PAGO CARTERA            | '04'     | 0052          |
#      | 'SODEXO'       | 'AH'        | '07'   | CONSULTA DE SALDO       | '05'     | 0002          |
#      | 'BIG PASS'     | 'CC'        | '80'   | CONSULTA DE SALDO       | '06'     | 0023          |
#      | 'BTERA.OTP'    | 'CR'        | '90'   | CONSULTA DE SALDO       | '07'     | 0051          |
#      | 'PTOSCOLMB'    | '00'        | '00'   | CONSULTA DE SALDO       | '08'     | 0001          |
#      | 'LIFEMILES'    | 'AH'        | '01'   | CONSULTAR CUPO          | '09'     | 0007          |
#      | 'MASTER DEBI'  | 'CC'        | '02'   | CONSULTAR CUPO          | '10'     | 0013          |
#      | 'MASTER'       | 'CR'        | '03'   | CONSULTAR CUPO          | '00'     | 0903          |
#      | '#MASTERD'     | '00'        | '05'   | CONSULTAR CUPO          | '01'     | 0052          |
#      | 'MASTER DEB'   | 'AH'        | '07'   | CAMBIO DE CLAVE         | '02'     | 1234          |
#      | 'MASTER DEBIT' | 'CC'        | '80'   | CAMBIO DE CLAVE         | '03'     | 0023          |
#      | 'VISA'         | 'CR'        | '90'   | CAMBIO DE CLAVE         | '04'     | 0051          |
#      | 'DINERS'       | '00'        | '00'   | CAMBIO DE CLAVE         | '05'     | 0001          |
#      | 'MASTER DEB'   | 'AH'        | '07'   | trx diferente           | '02'     | 1234          |
#      | 'MASTER DEBIT' | 'CC'        | '80'   | trx diferente           | '03'     | 6666          |
#      | 'VISA'         | 'CR'        | '90'   | trx diferente           | '04'     | 7777          |
#      | 'DINERS'       | '00'        | '00'   | trx diferente           | '05'     | 8888          |
      | 'VISA MASTER'  | 'WW'        | '90'   | trx diferente           | '04'     | 5555          |
      | 'DINERS DINER' | 'QQ'        | 'WW'   | trx diferente           | '05'     | 4444          |
      | 'DINERS'       | 'XX'        | 'ÑÑ'   | trx diferente           | '05'     | 3333          |
      | 'VISA MASTER'  | 'SS'        | 'PP'   | trx diferente           | '04'     | 2222          |
      | 'DINERS DINTT' | '22'        | 'FF'   | trx diferente           | '05'     | 2255          |

