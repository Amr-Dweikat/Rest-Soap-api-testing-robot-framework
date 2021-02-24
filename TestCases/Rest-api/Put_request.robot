*** Settings ***
Library  Collections
Resource  ../../Helper/Helper.robot


*** Variables ***
${ROOT_ENDPOINT}  http://localhost:8080/jakarta-ee-getting-started/rest
${PATH}  /accountHolders/


*** Test Cases ***
Update existing account holder with valid information
    ${account_information}  create dictionary  id=3  firstName=a  lastName=z  balance=${200}
    Helper.updateValidAccountInformation  ${ROOT_ENDPOINT}  ${PATH}  3  ${account_information}


Update existing account holder with missing fields
    ${account_information}  create dictionary  id=3  firstName=a
    Helper.updateAccountWithMissingFields  ${ROOT_ENDPOINT}  ${PATH}  3  ${account_information}


Update existing account holder with invalid information
    ${account_information}  create dictionary  id=3  firstName=a  lastName=z  balance=aaa
    Helper.updateAccountWithInvalidInformation  ${ROOT_ENDPOINT}  ${PATH}  3  ${account_information}


Update existing account holder with existing account id
     ${account_information}  create dictionary  id=1  firstName=sds  lastName=z  balance=${100}
     Helper.updateAccountWithExistingAccount  ${ROOT_ENDPOINT}  ${PATH}  3  ${account_information}


Update non existing account holder
    ${account_information}  create dictionary  id=1000  firstName=a  lastName=z  balance=${222}
    Helper.updateNonExistingAccount  ${ROOT_ENDPOINT}  ${PATH}  1000  ${account_information}