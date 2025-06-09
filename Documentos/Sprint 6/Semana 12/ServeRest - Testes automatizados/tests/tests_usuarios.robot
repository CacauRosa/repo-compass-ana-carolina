*** Settings ***
Resource            ../resources/geral_keywords.robot

Suite Setup         Criar sessão na API

*** Test Cases ***
CT07: POST Cadastrar usuário com e-mail gmail
    [TAGS]      cadastro_padrões
    POST Endpoint /usuarios com email incorreto           gmail
    Validar status code                                   400    
    Validar mensagem retornada                            email deve ser um email válido 

CT07: POST Cadastrar usuário com e-mail hotmail
    [TAGS]      cadastro_padrões
    POST Endpoint /usuarios com email incorreto           hotmail
    Validar status code                                   400  
    Validar mensagem retornada                            email deve ser um email válido

CT08: POST Cadastrar usuário com e-mail fora do padrão válido
    [TAGS]      cadastro_padrões
    POST Endpoint /usuarios com email fora do padrão válido
    Validar status code                     400      
    Validar mensagem retornada no CT08      email deve ser um email válido

CT09: POST Cadastrar usuário com senha válida
    [TAGS]      cadastro_padrões
    Mostrar senha válida
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT10: POST Cadastrar usuário com senha inválida curta
    [TAGS]      cadastro_padrões
    POST Endpoint /usuarios com senha curta
    Validar status code             400
    Validar mensagem retornada      senha deve ser uma senha válida

CT11: POST Cadastrar usuário com senha inválida longa
    [TAGS]      cadastro_padrões
    POST Endpoint /usuarios com senha longa
    Validar status code             400
    Validar mensagem retornada      senha deve ser uma senha válida

CT05: POST Cadastrar usuário com os campos válidos
    [TAGS]      cadastro
    POST Endpoint /usuarios
    Validar status code             201
    Validar mensagem retornada      Cadastro realizado com sucesso

CT06: POST Cadastrar usuário com e-mail já utilizado
    [TAGS]      cadastro
    POST Endpoint /usuarios com email já utilizado
    Validar status code             400
    Validar mensagem retornada      Este email já está sendo usado

CT12: GET Listar usuários cadastrados
    [TAGS]      listar_buscar
    POST Endpoint /usuarios
    GET Endpoint /usuarios
    Validar status code             200
    Validar resposta não vazia

CT13: GET Buscar usuário com ID válido
    [TAGS]      listar_buscar
    POST Endpoint /usuarios
    GET Endpoint /usuarios/{_id}
    Validar status code             200
    Validar resposta não vazia

CT14: GET Buscar usuário com ID inexistente
    [TAGS]      listar_buscar
    GET Endpoint /usuarios/{_id} com ID inexistente
    Validar status code             400
    Validar mensagem retornada      Usuário não encontrado