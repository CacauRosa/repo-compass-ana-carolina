*** Settings ***
Documentation       Arquivo contendo os testes das requisições HTTP da API Restful-booker (https://restful-booker.herokuapp.com/apidoc/index.html)
Resource            ../resources/keywords.robot


*** Test Cases ***
Cenário 1: POST Criar token de autenticação 200
    [tags]      AUTH
    Criar sessão na API
    POST Endpoint /auth
    Validar status code "200"
    Conferir se foi gerado um token de autenticação
    Guardar token gerado

Cenário 2: GET Todos os IDs das reservas 200
    [tags]      GETtudo
    Criar sessão na API
    GET Endpoint /booking
    Validar status code "200"

Cenário 3: GET ID da reserva por nome 200
    [tags]      GETnome
    Criar sessão na API
    GET Endpoint /booking por nome      Sally     Brown
    Validar status code "200"

Cenário 4: GET ID da reserva por data 200
    [tags]      GETdata
    Criar sessão na API
    GET Endpoint /booking por data      2018-01-01       2019-01-01
    Validar status code "200"

Cenário 5: GET Reserva por ID 200
    [tags]      GETreserva
    Criar sessão na API
    Pegar ID de usuário criado
    GET Endpoint /booking/{id}
    Validar status code "200"

Cenário 6: POST Nova reserva 200
    [tags]      POST
    Criar sessão na API
    Criar nome aleatório
    POST Endpoint /booking
    Validar status code "200"

Cenário 7: PUT Atualizar reserva 200
    [tags]      PUT
    Criar sessão com autenticação
    Pegar ID de usuário criado
    PUT Endpoint /booking/{id}
    Validar status code "200"

Cenário 8: PATCH Atualizar apenas nome na reserva 200
    [tags]      PATCH
    Criar sessão com autenticação
    Pegar ID de usuário criado
    PATCH Endpoint /booking/{id}
    Validar status code "200"

Cenário 9: DELETE Deletar reserva 201
    [tags]      DELETE
    Criar sessão com autenticação
    Pegar ID de usuário criado
    DELETE Endpoint /booking/{id}
    Validar status code "201"