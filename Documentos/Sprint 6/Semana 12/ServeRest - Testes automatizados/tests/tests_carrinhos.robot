*** Settings ***
Resource            ../resources/geral_keywords.robot

Suite Setup         Criar sessão na API

*** Test Cases ***
CT32: POST Cadastrar carrinho com usuário válido
    [TAGS]      cadastro
    POST Endpoint /carrinhos
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT34: GET Listar carrinhos cadastrados
    [TAGS]      listar_buscar
    POST Endpoint /carrinhos
    GET Endpoint /carrinhos
    Validar status code             200
    Validar resposta não vazia

CT35: GET Buscar carrinho com ID válido
    [TAGS]      listar_buscar
    POST Endpoint /carrinhos
    GET Endpoint /carrinhos/{_id}
    Validar status code             200
    Validar resposta não vazia