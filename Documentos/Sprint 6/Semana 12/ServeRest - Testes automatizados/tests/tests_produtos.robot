*** Settings ***
Resource            ../resources/geral_keywords.robot

Suite Setup         Criar sessão na API

*** Test Cases ***
CT20: POST Cadastrar produto em POST com dados válidos
    [TAGS]      cadastro
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT21: POST Cadastrar produto em POST com usuário não autenticado
    [TAGS]      cadastro
    POST Endpoint /produtos sem autenticação
    Validar status code             401
    Validar mensagem retornada      Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT22: POST Cadastrar produto em POST com nome já utilizado
    [TAGS]      cadastro
    Criar sessão e obter token
    POST Endpoint /produtos com nome já utilizado
    Validar status code             400
    Validar mensagem retornada      Já existe produto com esse nome

CT24: GET Listar produtos cadastrados
    [TAGS]      listar_buscar
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    GET Endpoint /produtos
    Validar status code             200
    Validar resposta não vazia

CT25: GET Buscar produto com ID válido
    [TAGS]      listar_buscar
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    GET Endpoint /produtos/{_id}
    Validar status code             200
    Validar resposta não vazia