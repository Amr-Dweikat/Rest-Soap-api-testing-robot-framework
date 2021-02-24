*** Settings ***
Library  Collections
Resource  ../../Helper/Helper.robot

*** Variables ***
${ROOT_ENDPOINT}  http://localhost:8080/jakarta-ee-getting-started/rest
${PATH}  /accountHolders/



*** Test Cases ***
Test total account holders
    Helper.validateTotalAccountHolders  ${ROOT_ENDPOINT}  ${PATH}  2


Test existing account information
    Helper.validateExistingAccountInformation  ${ROOT_ENDPOINT}  ${PATH}  1

Test non existing account
    Helper.validateNonExistingAccountInformation  ${ROOT_ENDPOINT}  ${PATH}  1000

