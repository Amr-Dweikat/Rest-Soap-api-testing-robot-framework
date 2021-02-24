*** Settings ***
Resource  ../../Helper/Helper.robot

*** Variables ***
${WSDL_URL}  http://localhost:8000/ws/transaction?wsdl


*** Test Cases ***
Test transaction for existing avialable source account and existing destenation account with valid amount
    Helper.TestEASED  ${WSDL_URL}  1  2  1


Test transaction for existing avialable source account and non existing destenation account with valid amount
    Helper.TestEASNED  ${WSDL_URL}  1  1000  1




Test transaction for existing and non avialable source account and existing destenation account with valid amount
    Helper.TestENASED  ${WSDL_URL}  1  2  1000

Test transaction for existing and non avialable source account and non existing destenation account with valid amount
    Helper.TestENASNED  ${WSDL_URL}  1  1000  1000




Test transaction for existing source account and existing destenation with invalid amount
    Helper.TestESEDWIA  ${WSDL_URL}  1  2  aaa


Test transaction for existing source account and non existing destenation with invalid amount
    Helper.TestESNEDWIA  ${WSDL_URL}  1  1000  aaa


Test transaction for non existing source account
    Helper.TestNES  ${WSDL_URL}  1000  2  1









