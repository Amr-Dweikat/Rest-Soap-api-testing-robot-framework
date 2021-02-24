*** Settings ***
Resource  ../../Helper/Helper.robot


*** Variables ***
${ROOT_ENDPOINT}  http://localhost:8080/jakarta-ee-getting-started/rest
${PATH}  /accountHolders/


*** Test Cases ***
Test delete existing account
    Helper.deleteExistingAccount  ${ROOT_ENDPOINT}  ${PATH}  3


Test delete non existing account
    Helper.deleteNonExistingAccount  ${ROOT_ENDPOINT}  ${PATH}  1000