*** Settings ***
Resource            ../resources/keywords.robot

Suite Setup         Criar sessão na API

*** Test Cases ***
CT01: POST Login com usuário existente
    [TAGS]      Login
    POST Endpoint /usuarios
    POST Endpoint /login
    Validar se foi gerado um token de autenticação
    Guardar token gerado
    Validar status code             200

CT02: POST Login com usuário existente e senha incorreta
    [TAGS]      Login
    Criar usuário e gerar senha incorreta
    POST Endpoint /login
    Validar status code             401
    Validar mensagem retornada      Email e/ou senha inválidos

CT03: POST Login com usuário inexistente
    [TAGS]      Login
    Gerar dados de usuário inexistente para login
    POST Endpoint /login
    Validar status code             401
    Validar mensagem retornada      Email e/ou senha inválidos

CT07: POST Cadastrar usuário com e-mail gmail
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com email incorreto           gmail
    Validar status code                                   400    
    Validar mensagem retornada                            email deve ser um email válido 

CT07: POST Cadastrar usuário com e-mail hotmail
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com email incorreto           hotmail
    Validar status code                                   400  
    Validar mensagem retornada                            email deve ser um email válido

CT08: POST Cadastrar usuário com e-mail fora do padrão válido
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com email fora do padrão válido
    Validar status code                     400      
    Validar mensagem retornada no CT08      email deve ser um email válido

CT09: POST Cadastrar usuário com senha válida
    [TAGS]      Cadastro_padrões
    Mostrar senha válida
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT10: POST Cadastrar usuário com senha inválida curta
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com senha curta
    Validar status code             400
    Validar mensagem retornada      senha deve ser uma senha válida

CT11: POST Cadastrar usuário com senha inválida longa
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com senha longa
    Validar status code             400
    Validar mensagem retornada      senha deve ser uma senha válida

CT05: POST Cadastrar usuário com os campos válidos
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT06: POST Cadastrar usuário com e-mail já utilizado
    [TAGS]      Cadastro_padrões
    POST Endpoint /usuarios com email já utilizado
    Validar status code             400
    Validar mensagem retornada      Este email já está sendo usado

CT20: POST Cadastrar produto em POST com dados válidos
    [TAGS]      Cadastro_padrões
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT21: POST Cadastrar produto em POST com usuário não autenticado
    [TAGS]      Cadastro_padrões
    POST Endpoint /produtos sem autenticação
    Validar status code             401
    Validar mensagem retornada      Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT22: POST Cadastrar produto em POST com nome já utilizado
    [TAGS]      Cadastro_padrões
    Criar sessão e obter token
    POST Endpoint /produtos com nome já utilizado
    Validar status code             400
    Validar mensagem retornada      Já existe produto com esse nome

CT32: POST Cadastrar carrinho com usuário válido
    [TAGS]      Cadastro_padrões
    POST Endpoint /carrinhos
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT12: GET Listar usuários cadastrados
    [TAGS]      Listar_buscar
    POST Endpoint /usuarios
    GET Endpoint /usuarios
    Validar status code             200
    Validar resposta não vazia

CT13: GET Buscar usuário com ID válido
    [TAGS]      Listar_buscar
    POST Endpoint /usuarios
    GET Endpoint /usuarios/{_id}
    Validar status code             200
    Validar resposta não vazia

CT14: GET Buscar usuário com ID inexistente
    [TAGS]      Listar_buscar
    GET Endpoint /usuarios/{_id} com ID inexistente
    Validar status code             400
    Validar mensagem retornada      Usuário não encontrado

CT24: GET Listar produtos cadastrados
    [TAGS]      Listar_buscar
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    GET Endpoint /produtos
    Validar status code             200
    Validar resposta não vazia

CT25: GET Buscar produto com ID válido
    [TAGS]      Listar_buscar
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    GET Endpoint /produtos/{_id}
    Validar status code             200
    Validar resposta não vazia

CT34: GET Listar carrinhos cadastrados
    [TAGS]      Listar_buscar
    POST Endpoint /carrinhos
    GET Endpoint /carrinhos
    Validar status code             200
    Validar resposta não vazia

CT35: GET Buscar carrinho com ID válido
    [TAGS]      Listar_buscar
    POST Endpoint /carrinhos
    GET Endpoint /carrinhos/{_id}
    Validar status code             200
    Validar resposta não vazia