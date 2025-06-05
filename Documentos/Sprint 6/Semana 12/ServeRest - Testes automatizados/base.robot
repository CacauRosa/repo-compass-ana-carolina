*** Settings ***
####Documentation       Arquivo contendo as keywords criadas para os testes das requisições HTTP da API Restful-booker (https://restful-booker.herokuapp.com/apidoc/index.html)
Library             RequestsLibrary
Library             Collections
Library             FakerLibrary


*** Variables ***
${URL_BASE}     compassuol.serverest.dev

*** Test Cases ***
# Critérios de automação: Usados com frequência e fluxos críticos
CT01: POST Login com usuário existente
    POST Endpoint /login

CT02: POST Login com usuário existente e senha incorreta
    POST Endpoint /login

CT03: POST Login com usuário inexistente
    POST Endpoint /login

# Critérios de automação: Requisitos estáveis e fluxos críticos
CT07: POST Criar usuário com e-mail gmail e hotmail
    POST Endpoint /usuarios

CT08: POST Criar usuário com e-mail fora do padrão válido
    POST Endpoint /usuarios

CT09: POST Criar usuário com senha válida
    POST Endpoint /usuarios

CT10: POST Criar usuário com senha inválida curta
    POST Endpoint /usuarios

CT11: POST Criar usuário com senha inválida longa
    POST Endpoint /usuarios

# Critérios de automação: Fluxos críticos
CT05: POST Cadastrar usuário com os campos válidos
    POST Endpoint /usuarios

CT06: POST Cadastrar usuário com e-mail já utilizado
    POST Endpoint /usuarios

CT20: POST Cadastrar produto em POST com dados válidos
    POST Endpoint /produtos

CT21: POST Cadastrar produto em POST com usuário não autenticado
    POST Endpoint /produtos

CT22: POST Cadastrar produto em POST com nome já utilizado
    POST Endpoint /produtos

CT32: POST Cadastrar carrinho com usuário válido
    POST Endpoint /carrinhos

# Critérios de automação: Resultados simples e previsíveis
CT12: GET Listar usuários cadastrados
    GET Endpoint /usuarios

CT13: GET Buscar usuário com ID válido
    GET Endpoint /usuarios

CT14: GET Buscar usuário com ID inexistente
    GET Endpoint /usuarios

CT24: GET Listar produtos cadastrados
    GET Endpoint /usuarios

CT25: GET Buscar produto com ID válido
    GET Endpoint /usuarios

CT34: GET Listar carrinhos cadastrados
    GET Endpoint /usuarios

CT35: GET Buscar carrinho com ID válido
    GET Endpoint /usuarios


*** Keywords ***