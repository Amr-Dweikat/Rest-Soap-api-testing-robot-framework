*** Settings ***
Library  Collections
Resource  ../../Helper/Helper.robot

*** Variables ***
${ROOT_ENDPOINT}  http://localhost:8080/jakarta-ee-getting-started/rest
${PATH}  /accountHolders/



*** Test Cases ***
Test add valid account holder
    ${account_information}  create dictionary  id=3  firstName=Ez  lastName=asd  balance=${3.5}
    Helper.createValidAccountHolder  ${ROOT_ENDPOINT}  ${PATH}  ${account_information}

Test add account holder with missing fields
    ${account_information}  create dictionary  id=4  firstName=Ez
    Helper.createAccountHolderWithMissingFields  ${ROOT_ENDPOINT}  ${PATH}  ${account_information}


Test add existing account holder
    ${account_information}  create dictionary  id=1  firstName=sds  lastName=asd  balance=${100}
    Helper.createExistingAccountHolder  ${ROOT_ENDPOINT}  ${PATH}  ${account_information}

Test add account holder with invalid data
    ${wrong_account_information}  create dictionary  id=5  firstName=Ez  lastName=asd  balance=aa
    Helper.createNonValidAccountHolder  ${ROOT_ENDPOINT}  ${PATH}  ${wrong_account_information}

