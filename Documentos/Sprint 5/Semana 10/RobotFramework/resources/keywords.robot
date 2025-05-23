*** Settings ***
Documentation       Arquivo contendo as keywords criadas para os testes das requisições HTTP da API Restful-booker (https://restful-booker.herokuapp.com/apidoc/index.html)
Library             RequestsLibrary
Library             String
Library             Collections


*** Keywords ***
Criar sessão na API
    Create Session      booker      https://restful-booker.herokuapp.com

Validar status code "${statuscode}"
    Should Be True      ${response.status_code} == ${statuscode}

POST Endpoint /auth
    ${body}                 Create Dictionary       username=admin  password=password123
    ${response}             POST On Session      booker      /auth       data=&{body}
    Log to Console          Token: ${response.content}
    Set Test Variable       ${response}

Conferir se foi gerado um token de autenticação
    Dictionary Should Contain Key       ${response.json()}      token

Guardar token gerado
    ${token}        Get From Dictionary       ${response.json()}      token
    Set Test Variable      ${token}

GET Endpoint /booking
    ${response}             GET On Session      booker      /booking
    Log to Console          Todos os IDs de reservas: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking por nome
    [Arguments]             ${firstname}        ${lastname}
    ${parameters}           Create Dictionary       firstname=${firstname}   lastname=${lastname}
    ${response}             GET On Session      booker      /booking        params=${parameters}
    Log to Console          ID da reserva de ${firstname} ${lastname}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking por data
    [Arguments]             ${checkin}        ${checkout}
    ${parameters}           Create Dictionary       checkin=${checkin}    checkout=${checkout}
    ${response}             GET On Session      booker      /booking        params=${parameters}
    Log to Console          ID da reserva de ${checkin} até ${checkout}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking/{id}
    ${response}             GET On Session      booker      /booking/${bookingid}
    Log to Console          Reserva do ID ${bookingid}: ${response.content}
    Set Test Variable       ${response}

Criar nome aleatório
    ${randomfirstname}           Generate Random String      length=5        chars=[LETTERS]
    ${randomfirstname}           Convert To Lower Case       ${randomfirstname} 
    ${randomfirstname}           Convert To Title Case       ${randomfirstname} 
    Set Global Variable       ${randomfirstname}
    ${randomlastname}           Generate Random String      length=5        chars=[LETTERS]
    ${randomlastname}           Convert To Lower Case       ${randomlastname} 
    ${randomlastname}           Convert To Title Case       ${randomlastname} 
    Set Global Variable       ${randomlastname} 

POST Endpoint /booking
    ${bookingdates}         Create Dictionary       checkin=2018-01-01      checkout=2019-01-01
    ${body}                 Create Dictionary
    ...                     firstname=${randomfirstname}
    ...                     lastname=${randomlastname}
    ...                     totalprice=130
    ...                     depositpaid=True
    ...                     bookingdates=${bookingdates} 
    ...                     additionalneeds=Breakfast
    ${response}             POST On Session     booker      /booking       json=${body}
    Log to Console          Nova reserva: ${response.content}
    Set Test Variable       ${response}

Criar sessão com autenticação
    Criar sessão na API
    POST Endpoint /auth
    Guardar token gerado

Pegar ID de usuário criado
    Criar nome aleatório
    POST Endpoint /booking
    ${bookingid}            Get From Dictionary     ${response.json()}      bookingid
    Set Test Variable       ${bookingid}

PUT Endpoint /booking/{id}
    ${header}               Create Dictionary       Cookie=token=${token}
    ${bookingdates}         Create Dictionary       checkin=2018-01-01      checkout=2019-01-01
    ${body}                 Create Dictionary
    ...                     firstname=Mark
    ...                     lastname=Lee
    ...                     totalprice=127
    ...                     depositpaid=True
    ...                     bookingdates=${bookingdates} 
    ...                     additionalneeds=Breakfast
    ${response}             PUT On Session     booker      /booking/${bookingid}       json=${body}     headers=${header}
    Log to Console          Reserva atualizada: ${response.content}
    Set Test Variable       ${response}

PATCH Endpoint /booking/{id}
    ${header}               Create Dictionary       Cookie=token=${token}
    ${body}                 Create Dictionary           firstname=John
    ${response}             PATCH On Session     booker      /booking/${bookingid}       json=${body}     headers=${header}
    Log to Console          Reserva atualizada: ${response.content}
    Set Test Variable       ${response}

DELETE Endpoint /booking/{id}       
    ${header}               Create Dictionary       Cookie=token=${token}
    ${response}             DELETE On Session       booker      /booking/${bookingid}       headers=${header}
    IF      '${response.content}' == 'Created'
        Log to Console    Reserva deletada: Sim
    ELSE
        Log to Console    Reserva deletada: Não
    END
    Set Test Variable       ${response}