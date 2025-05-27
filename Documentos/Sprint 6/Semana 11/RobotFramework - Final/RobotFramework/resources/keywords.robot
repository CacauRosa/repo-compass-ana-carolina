*** Settings ***
Documentation       Arquivo contendo as keywords criadas para os testes das requisições HTTP da API Restful-booker (https://restful-booker.herokuapp.com/apidoc/index.html)
Library             RequestsLibrary
Library             Collections
Library             FakerLibrary
Library             DateTime

Resource            ../resources/variables.robot


*** Keywords ***
Criar sessão na API
    Create Session      booker      ${URL_BASE}

Validar status code
    [Arguments]         ${statuscode}
    Should Be True      ${response.status_code} == ${statuscode}        Status code esperado: ${statuscode}, recebido: ${response.status_code}

POST Endpoint /auth
    ${body}                 Create Dictionary       username=${ADMIN_USERNAME}  password=${ADMIN_PASSWORD}
    ${response}             POST On Session      booker      /auth       data=&{body}
    Log to Console          Token: ${response.content}
    Set Test Variable       ${response}

Conferir se foi gerado um token de autenticação
    Dictionary Should Contain Key       ${response.json()}      token

Guardar token gerado
    ${token}        Get From Dictionary       ${response.json()}      token
    Set Test Variable      ${token}

Validar resposta não vazia
    Should Not Be Empty    ${response.content}    A resposta da API está vazia

GET Endpoint /booking
    ${response}             GET On Session      booker      /booking
    Log to Console          Todos os IDs de reservas: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking por nome
    ${parameters}           Create Dictionary       firstname=${firstname}   lastname=${lastname}
    ${response}             GET On Session      booker      /booking        params=${parameters}
    Log to Console          ID da reserva de ${firstname} ${lastname}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking por data
    ${parameters}           Create Dictionary       checkin=${checkin_str}    checkout=${checkout_str}
    ${response}             GET On Session      booker      /booking        params=${parameters}
    Log to Console          ID da reserva de ${checkin_str} até ${checkout_str}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /booking/{id}
    ${response}             GET On Session      booker      /booking/${bookingid}
    Log to Console          Reserva do ID ${bookingid}: ${response.content}
    Set Test Variable       ${response}

Criar dados dinâmicos
    ${checkin}              FakerLibrary.Date Between       -2y             -30d
    ${checkout}             FakerLibrary.Date Between       ${checkin}      today
    ${checkin_str}          DateTime.Convert Date           ${checkin}      result_format=%Y-%m-%d
    ${checkout_str}         DateTime.Convert Date           ${checkout}     result_format=%Y-%m-%d
    Set Test Variable       ${checkin_str} 
    Set Test Variable       ${checkout_str}  

    ${firstname}            FakerLibrary.First Name
    Set Test Variable       ${firstname}
    ${lastname}             FakerLibrary.Last Name
    Set Test Variable       ${lastname}
    ${totalprice}           Evaluate        random.randint(100, 1000)        random
    Set Test Variable       ${totalprice}
    ${depositpaid}          FakerLibrary.Boolean
    Set Test Variable       ${depositpaid}

POST Endpoint /booking
    ${bookingdates}         Create Dictionary       checkin=${checkin_str}      checkout=${checkout_str}
    ${body}                 Create Dictionary
    ...                     firstname=${firstname}
    ...                     lastname=${lastname}
    ...                     totalprice=${totalprice}
    ...                     depositpaid=${depositpaid}
    ...                     bookingdates=${bookingdates} 
    ...                     additionalneeds=Lunch and dinner
    ${response}             POST On Session     booker      /booking       json=${body}
    Log to Console          Nova reserva: ${response.content}
    Set Test Variable       ${response}

Criar sessão com autenticação
    Criar sessão na API
    POST Endpoint /auth
    Guardar token gerado

Criar reserva e obter ID
    Criar dados dinâmicos
    POST Endpoint /booking
    ${bookingid}            Get From Dictionary     ${response.json()}      bookingid
    Set Test Variable       ${bookingid}

PUT Endpoint /booking/{id}
    ${header}               Create Dictionary       Cookie=token=${token}
    ${bookingdates}         Create Dictionary       checkin=${checkin_str}      checkout=${checkout_str}
    ${body}                 Create Dictionary
    ...                     firstname=${firstname}
    ...                     lastname=${lastname}
    ...                     totalprice=${totalprice}
    ...                     depositpaid=${depositpaid}
    ...                     bookingdates=${bookingdates} 
    ...                     additionalneeds=Lunch and dinner
    ${response}             PUT On Session     booker      /booking/${bookingid}       json=${body}     headers=${header}
    Log to Console          Reserva atualizada: ${response.content}
    Set Test Variable       ${response}

PATCH Endpoint /booking/{id}
    ${header}               Create Dictionary       Cookie=token=${token}
    ${body}                 Create Dictionary           firstname=${firstname}
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