*** Settings ***
Documentation       Arquivo contendo os testes das requisições HTTP da API Restful-booker (https://restful-booker.herokuapp.com/apidoc/index.html)
Resource            ../resources/keywords.robot

Suite Setup         Criar sessão na API


*** Test Cases ***
Cenário 1: POST Criar token de autenticação 200
    [tags]      AUTH
    POST Endpoint /auth
    Validar status code     200
    Conferir se foi gerado um token de autenticação
    Guardar token gerado

Cenário 2: GET Todos os IDs das reservas 200
    [tags]      GETtudo
    GET Endpoint /booking
    Validar resposta não vazia
    Validar status code     200

Cenário 3: GET ID da reserva por nome 200
    [tags]      GETnome
    Criar dados dinâmicos
    POST Endpoint /booking
    GET Endpoint /booking por nome
    Validar resposta não vazia
    Validar status code     200

Cenário 4: GET ID da reserva por data 200
    [tags]      GETdata
    Criar dados dinâmicos
    POST Endpoint /booking
    GET Endpoint /booking por data
    Validar resposta não vazia
    Validar status code     200

Cenário 5: GET Reserva por ID 200
    [tags]      GETreserva
    Criar reserva e obter ID
    GET Endpoint /booking/{id}
    Validar resposta não vazia
    Validar status code     200

Cenário 6: POST Nova reserva 200
    [tags]      POST
    Criar dados dinâmicos
    POST Endpoint /booking
    Validar resposta não vazia
    Validar status code     200

Cenário 7: PUT Atualizar reserva 200
    [tags]      PUT
    Criar sessão com autenticação
    Criar reserva e obter ID
    Criar dados dinâmicos
    PUT Endpoint /booking/{id}
    Validar resposta não vazia
    Validar status code     200

Cenário 8: PATCH Atualizar apenas nome na reserva 200
    [tags]      PATCH
    Criar sessão com autenticação
    Criar reserva e obter ID
    Criar dados dinâmicos
    PATCH Endpoint /booking/{id}
    Validar resposta não vazia
    Validar status code     200

Cenário 9: DELETE Deletar reserva 201
    [tags]      DELETE
    Criar sessão com autenticação
    Criar reserva e obter ID
    DELETE Endpoint /booking/{id}
    Validar resposta não vazia
    Validar status code     201