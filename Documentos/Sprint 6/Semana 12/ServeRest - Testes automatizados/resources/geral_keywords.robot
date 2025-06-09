*** Settings ***
Library             RequestsLibrary
Library             Collections
Library             FakerLibrary

Resource            variables.robot
Resource            login_keywords.robot
Resource            usuarios_keywords.robot
Resource            produtos_keywords.robot
Resource            carrinhos_keywords.robot 

*** Keywords ***
Criar sessão na API
    Create Session      serverest      ${URL_BASE}

Validar status code
    [Arguments]          ${status_code}
    Should Be True       ${response.status_code}==${status_code}           O status code deveria ser "${status_code}" e não "${response.status_code}"

Validar mensagem retornada
    [Arguments]         ${mensagem}
    Should Be Equal     ${response.json()["message"]}       ${mensagem}        A mensagem deveria ser "${mensagem}" e não "${response.json()["message"]}"
    Log To Console      ${response.json()["message"]}

Validar resposta não vazia
    Should Not Be Empty     ${response.json()}      Nenhuma informação foi retornada pela API