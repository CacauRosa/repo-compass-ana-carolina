*** Settings ***
Resource            ../resources/geral_keywords.robot

Suite Setup         Criar sessão na API

*** Test Cases ***
CT01: POST Login com usuário existente
    [TAGS]      login
    POST Endpoint /usuarios
    POST Endpoint /login
    Validar se foi gerado um token de autenticação
    Guardar token gerado
    Validar status code             200

CT02: POST Login com usuário existente e senha incorreta
    [TAGS]      login
    Criar usuário e gerar senha incorreta
    POST Endpoint /login
    Validar status code             401
    Validar mensagem retornada      Email e/ou senha inválidos

CT03: POST Login com usuário inexistente
    [TAGS]      login
    Gerar dados de usuário inexistente para login
    POST Endpoint /login
    Validar status code             401
    Validar mensagem retornada      Email e/ou senha inválidos