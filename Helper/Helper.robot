*** Settings ***
Library  RequestsLibrary
Library  SoapLibrary
Library  Collections
Library    JsonToDict

*** Variables ***
${ROOT_ENDPOINT}  http://localhost:8080/jakarta-ee-getting-started/rest
${PATH}  /accountHolders/


*** Keywords ***
#Rest api


#Get request
validateTotalAccountHolders
    [Arguments]  ${root_endpoint}  ${path}  ${total_accounts}
    create session  mysession  ${root_endpoint}
    ${response}  GET On Session  mysession  ${path}
    should be equal as strings  ${response.status_code}  200  response code should be 200
    ${total_ac}  get length  ${response.json()}
    should be equal as strings  ${total_ac}  ${total_accounts}  the total account holders must be ${total_accounts}

validateExistingAccountInformation
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}
    create session  mysession  ${root_endpoint}
    ${all_accounts}  GET On Session  mysession  ${path}
    ${response}  GET On Session  mysession  ${path}${account_id}
    should be equal as strings  ${response.status_code}  200  response code should be 200
    FOR   ${item}    IN    @{all_accounts.json()}
       ${id}  get from dictionary  ${item}  id
       run keyword if  ${id} == ${account_id}  exist  ${response.json()}  ${item}
    END



exist
    [Arguments]  ${response}  ${my_response}
    should be equal  ${response}  ${my_response}   get method does not return the correct account


validateNonExistingAccountInformation
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}
    create session  musession  ${root_endpoint}
    ${response}  GET On Session  mysession  ${path}${account_id}
    should be equal as strings  ${response.status_code}  204  account should be not exist


#Post request
createValidAccountHolder
     [Arguments]  ${root_endpoint}  ${path}  ${account_information}
     create session  mysession  ${root_endpoint}
     ${response}  POST On Session  mysession  ${path}  json=${account_information}
     should be equal as strings  ${response.status_code}  201  response code should be 201
     ${account_id}  get from dictionary  ${account_information}  id
     ${get_response}  GET On Session  mysession  ${path}${account_id}
     should be equal as strings  ${get_response.status_code}  200  account holder does not added
     should be equal  ${get_response.json()}  ${account_information}  the account information that added not same this ${account_information}


createAccountHolderWithMissingFields
     [Arguments]  ${root_endpoint}  ${path}  ${account_information}
     create session  mysession  ${root_endpoint}
     ${response}  run keyword and ignore error  POST On Session  mysession  ${path}  json=${account_information}
     should contain  ${response}[1]  500 Server Error  should not be add a account with missing information

createExistingAccountHolder
     [Arguments]  ${root_endpoint}  ${path}  ${account_information}
     create session  mysession  ${root_endpoint}
     ${response}  run keyword and ignore error  POST On Session  mysession  ${path}  json=${account_information}
     should contain  ${response}[1]  500 Server Error  account already exist


createNonValidAccountHolder
     [Arguments]  ${root_endpoint}  ${path}  ${wrong_account_information}
     create session  mysession  ${root_endpoint}
     ${response}  run keyword and ignore error  POST On Session  mysession  ${path}  json=${wrong_account_information}
     should contain  ${response}[1]  500 Server Error  this account mustn't be added



#Put request
updateValidAccountInformation
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}  ${account_information}
    create session  mysession  ${root_endpoint}
    ${response}  PUT On Session  mysession  ${path}${account_id}  json=${account_information}
    ${new_account_id}  get from dictionary  ${account_information}  id
    ${get_response}  GET On Session  mysession  ${path}${new_account_id}
    should be equal as strings  ${get_response.status_code}  200  status code should be 200
    should be equal  ${get_response.json()}  ${account_information}


updateAccountWithMissingFields
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}  ${account_information}
    create session  mysession  ${root_endpoint}
    ${response}  run keyword and ignore error  PUT On Session  mysession  ${path}${account_id}  json=${account_information}
    should contain  ${response}[1]  500 Server Error  should not be update a account with missing information


updateAccountWithInvalidInformation
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}  ${account_information}
    create session  mysession  ${root_endpoint}
    ${response}  run keyword and ignore error  PUT On Session  mysession  ${path}${account_id}  json=${account_information}
    should contain  ${response}[1]  500 Server Error  should not be update a account with invalid information


updateAccountWithExistingAccount
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}  ${account_information}
    create session  mysession  ${root_endpoint}
    ${response}  run keyword and ignore error  PUT On Session  mysession  ${path}${account_id}  json=${account_information}
    log to console  ${response}
    should contain  ${response}[1]  500 Server Error  should not be update a account with existing account information


updateNonExistingAccount
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}  ${account_information}
    create session  mysession  ${root_endpoint}
    ${response}  PUT On Session  mysession  ${path}${account_id}  json=${account_information}
    should be equal as strings  ${response.status_code}  204  updated account that already not exist




#Delete request
deleteExistingAccount
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}
    create session  mysession  ${root_endpoint}
    ${response}  DELETE On Session  mysession  ${path}${account_id}
    should be equal as strings  ${response.status_code}  200  there is an error in delete request
    validateNonExistingAccountInformation  ${root_endpoint}  ${path}  ${account_id}



deleteNonExistingAccount
    [Arguments]  ${root_endpoint}  ${path}  ${account_id}
    create session  mysession  ${root_endpoint}
    ${response}  DELETE On Session  mysession  ${path}${account_id}
    should be equal as strings  ${response.status_code}  204  this account must be already does not exist



#Soap api

TestEASED
    [Arguments]  ${wsdl_file}  ${source_id}  ${dest_id}  ${amount}
    Create Session  mysession  ${ROOT_ENDPOINT}
    ${get_src_before}  GET On Session  mysession  ${PATH}${source_id}
    ${get_des_before}  GET On Session  mysession  ${PATH}${dest_id}

    Create SOAP Client  ${wsdl_file}
    ${arguments}  create dictionary  amount=${amount}  from=${source_id}  to=${dest_id}  id=None
    ${response}  run keyword and ignore error  Call SOAP Method  createTransaction  ${arguments}
    should be equal  ${response}[0]  PASS  transaction must work in this case


    ${get_src_after}  GET On Session  mysession  ${PATH}${source_id}
    ${get_des_after}  GET On Session  mysession  ${PATH}${dest_id}

    ${balance_src_before}  get from dictionary  ${get_src_before.json()}  balance
    ${balance_src_bef}  evaluate  ${balance_src_before}-${amount}

    ${balance_des_before}  get from dictionary  ${get_des_before.json()}  balance
    ${balance_des_bef}  evaluate  ${balance_des_before}+${amount}

    ${balance_src_after}  get from dictionary  ${get_src_after.json()}  balance
    ${balance_des_after}  get from dictionary  ${get_des_after.json()}  balance

    should be equal  ${balance_src_bef}  ${balance_src_after}  transaction not work correctly at source account
    should be equal  ${balance_des_bef}  ${balance_des_after}  transaction not work correctly at destination account




TestEASNED
    [Arguments]  ${wsdl_file}  ${source_id}  ${dest_id}  ${amount}
    Create SOAP Client  ${wsdl_file}
    ${arguments}  create dictionary  amount=${amount}  from=${source_id}  to=${dest_id}  id=None
    Create Session  mysession  ${ROOT_ENDPOINT}
    ${get_before_response}  GET On Session  mysession  ${PATH}
    ${response}  run keyword and ignore error  Call SOAP Method  createTransaction  ${arguments}
    should be equal  ${response}[0]  FAIL  transaction should not be work when destination non exist
    ${get_after_response}  GET On Session  mysession  ${PATH}
    should be equal  ${get_before_response.json()}  ${get_after_response.json()}  transaction should not be work when destination non exist



TestENAS
    [Arguments]  ${wsdl_file}  ${source_id}  ${dest_id}  ${amount}
    Create SOAP Client  ${wsdl_file}
    ${arguments}  create dictionary  amount=${amount}  from=${source_id}  to=${dest_id}  id=None
    Create Session  mysession  ${ROOT_ENDPOINT}
    ${get_before_response}  GET On Session  mysession  ${PATH}
    ${response}  run keyword and ignore error  Call SOAP Method  createTransaction  ${arguments}
    should be equal  ${response}[0]  FAIL  transaction should not be work when source has balance lower than ${amount}
    ${get_after_response}  GET On Session  mysession  ${PATH}
    should be equal  ${get_before_response.json()}  ${get_after_response.json()}  transaction should not be work when source has balance lower than ${amount}




TestESWIA
    [Arguments]  ${wsdl_file}  ${source_id}  ${dest_id}  ${amount}
    Create SOAP Client  ${wsdl_file}
    ${arguments}  create dictionary  amount=${amount}  from=${source_id}  to=${dest_id}  id=None
    Create Session  mysession  ${ROOT_ENDPOINT}
    ${get_before_response}  GET On Session  mysession  ${PATH}
    ${response}  run keyword and ignore error  Call SOAP Method  createTransaction  ${arguments}
    should be equal  ${response}[0]  FAIL  transaction should not work when amount not valid
    ${get_after_response}  GET On Session  mysession  ${PATH}
    should be equal  ${get_before_response.json()}  ${get_after_response.json()}  transaction should not work when amount not valid





TestNES
    [Arguments]  ${wsdl_file}  ${source_id}  ${dest_id}  ${amount}
    Create Session  mysession  ${ROOT_ENDPOINT}
    ${get_before_response}  GET On Session  mysession  ${PATH}
    Create SOAP Client  ${wsdl_file}
    ${arguments}  create dictionary  amount=${amount}  from=${source_id}  to=${dest_id}  id=None
    ${response}  run keyword and ignore error  Call SOAP Method  createTransaction  ${arguments}
    should be equal  ${response}[0]  FAIL  transaction should not work when source account non exist
    ${get_after_response}  GET On Session  mysession  ${PATH}
    should be equal  ${get_before_response.json()}  ${get_after_response.json()}  transaction should not work when source account non exist





