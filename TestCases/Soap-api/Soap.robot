*** Settings ***
Resource  ../../Helper/Helper.robot

*** Variables ***
${WSDL_URL}  http://localhost:8000/ws/transaction?wsdl


*** Test Cases ***
Test transaction for existing avialable source account and existing destenation account with valid amount
    Helper.TestEASED  ${WSDL_URL}  1  2  1


Test transaction for existing avialable source account and non existing destenation account with valid amount
    Helper.TestEASNED  ${WSDL_URL}  1  1000  1


Test transaction for existing non avialable source account and with valid amount
    Helper.TestENAS  ${WSDL_URL}  1  1000  8000


Test transaction for existing source account with invalid amount
    Helper.TestESWIA  ${WSDL_URL}  1  2  aa



Test transaction for non existing source account
    Helper.TestNES  ${WSDL_URL}  1000  2  1









