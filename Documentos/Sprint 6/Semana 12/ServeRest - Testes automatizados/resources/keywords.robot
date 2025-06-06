*** Settings ***
Library             RequestsLibrary
Library             Collections
Library             FakerLibrary

Resource            variables.robot     

*** Keywords ***
Criar sessão na API
    Create Session      serverest      ${URL_BASE}

Validar status code
    [Arguments]          ${status_code}
    Should Be True       ${response.status_code}==${status_code}           O status code deveria ser "${status_code}" e não "${response.status_code}"

Validar mensagem retornada
    [Arguments]         ${mensagem}
    Should Be Equal     ${response.json()["message"]}       ${mensagem}        A mensagem deveria ser "${mensagem}" e não "${response.json()["message"]}"
    Log To Console      ${response.json()["message"]}

Validar resposta não vazia
    Should Not Be Empty     ${response.json()}      Nenhuma informação foi retornada pela API

#Login
*** Keywords ***
POST Endpoint /login
    ${body}                 Create Dictionary       email=${email}      password=${password}
    ${response}             POST On Session     serverest       /login      json=${body}        expected_status=any
    Log To Console          Email: ${email}\nSenha: ${password}
    Set Test Variable       ${response}

Validar se foi gerado um token de autenticação
    Should Not Be Empty     ${response.json()["authorization"]}     Token de autenticação não foi gerado
    Log to Console          Token: ${response.json()["authorization"]}      Token de autenticação não foi gerado

Guardar token gerado
    ${token}                Get From Dictionary       ${response.json()}      authorization
    Set Test Variable       ${token}

Criar usuário e gerar senha incorreta
    POST Endpoint /usuarios
    ${caracteres}           Evaluate        random.randint(5, 10)       random
    ${password}             FakerLibrary.Password       length=${caracteres}        special_chars=False
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Senha incorreta gerada: ${password}
    Set Test Variable       ${password}

Gerar dados de usuário inexistente para login
    ${email}                FakerLibrary.Email
    ${caracteres}           Evaluate        random.randint(5, 10)       random
    ${password}             FakerLibrary.Password       length=${caracteres}        special_chars=False
    Log To Console          Email inexistente gerado: ${email}\nSenha inexistente gerada: ${password}
    Set Test Variable       ${email}
    Set Test Variable       ${password}

#Usuários
Body para cadastro de usuário
    ${primeiro_nome}        FakerLibrary.First Name
    ${sobrenome}            FakerLibrary.Last Name
    ${email}                FakerLibrary.Email
    ${caracteres}           Evaluate        random.randint(5, 10)       random
    ${caracteres_int}       Convert To Integer      ${caracteres}           
    ${password}             FakerLibrary.Password       length=${caracteres_int}        special_chars=False
    ${body}                 Create Dictionary
    ...                     nome=${primeiro_nome} ${sobrenome}
    ...                     email=${email}
    ...                     password=${password}
    ...                     administrador=true
    Set Test Variable       ${body}
    Set Test Variable       ${email}
    Set Test Variable       ${password}

POST Endpoint /usuarios com email incorreto
    [Arguments]             ${dominio_email}
    Body para cadastro de usuário
    ${nome_email}           FakerLibrary.User Name
    ${email}                Set Variable        ${nome_email}@${dominio_email}.com
    Set To Dictionary       ${body}             email=${email}
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário criado com e-mail incorreto: ${body}
    Set Test Variable       ${response}

POST Endpoint /usuarios com email fora do padrão válido
    Body para cadastro de usuário
    ${nome_email}           FakerLibrary.User Name
    ${email}                Set Variable        ${nome_email}.com
    Set To Dictionary       ${body}             email=${email}
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário criado com e-mail fora do padrão válido: ${body}
    Set Test Variable       ${response}

Validar mensagem retornada no CT08
    [Arguments]         ${mensagem}
    Should Be Equal     ${response.json()["email"]}       ${mensagem}        A mensagem deveria ser "${mensagem}" e não "${response.json()["email"]}"
    Log To Console      ${response.json()["email"]}

Mostrar senha válida
    POST Endpoint /usuarios
    Log To Console          Senha válida utilizada: ${password}

POST Endpoint /usuarios com senha curta
    Body para cadastro de usuário
    ${caracteres}           Evaluate        random.randint(2, 4)       random
    ${caracteres_int}       Convert To Integer          ${caracteres}
    ${password}             FakerLibrary.Password       length=${caracteres_int}        special_chars=False
    Set To Dictionary       ${body}                     password=${password}
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário criado com senha curta: ${body}
    Set Test Variable       ${response}

POST Endpoint /usuarios com senha longa
    Body para cadastro de usuário
    ${caracteres}           Evaluate        random.randint(11, 25)       random
    ${caracteres_int}       Convert To Integer          ${caracteres}
    ${password}             FakerLibrary.Password       length=${caracteres_int}        special_chars=False
    Set To Dictionary       ${body}                     password=${password}
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário criado com senha longa: ${body}
    Set Test Variable       ${response}



POST Endpoint /usuarios
    Body para cadastro de usuário
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário criado: ${body}
    Set Test Variable       ${body}
    Set Test Variable       ${email}
    Set Test Variable       ${password}
    Set Test Variable       ${response}

POST Endpoint /usuarios com email já utilizado
    POST Endpoint /usuarios
    ${email_utilizado}      Set Variable        ${body["email"]}
    Body para cadastro de usuário
    Set To Dictionary       ${body}             email=${email_utilizado}
    ${response}             POST On Session     serverest       /usuarios      json=${body}     expected_status=any
    Log To Console          Usuário com email já utilizado: ${body}
    Set Test Variable       ${response}



GET Endpoint /usuarios
    ${id}                   Get From Dictionary     ${response.json()}                _id
    ${nome}                 Get From Dictionary     ${body}                nome
    ${email}                Get From Dictionary     ${body}                email
    ${password}             Get From Dictionary     ${body}                password
    ${administrador}        Get From Dictionary     ${body}                administrador
    ${parameters}           Create Dictionary       
    ...                     _id=${id} 
    ...                     nome=${nome}
    ...                     email=${email} 
    ...                     password=${password} 
    ...                     administrador=${administrador}
    ${response}             GET On Session      serverest      /usuarios        expected_status=any       params=${parameters}
    Log to Console          Usuário de id ${_id}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /usuarios/{_id}
    ${id}                   Get From Dictionary     ${response.json()}     _id
    ${response}             GET On Session      serverest      /usuarios/${id}        expected_status=any
    Log to Console          Usuário de id ${_id}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /usuarios/{_id} com ID inexistente
    ${id_aleatorio}         FakerLibrary.Password       length=16       special_chars=False     digits=False       
    ${response}             GET On Session      serverest      /usuarios/${id_aleatorio}        expected_status=any
    Set Test Variable       ${response}

#Produtos
Criar sessão e obter token
    Criar sessão na API
    POST Endpoint /usuarios
    POST Endpoint /login
    Guardar token gerado

Body para cadastro de produto
    ${nome}                 FakerLibrary.Word
    ${preco}                FakerLibrary.Random Int       min=50
    ${descricao}            FakerLibrary.Paragraph        nb_sentences=1
    ${quantidade}           FakerLibrary.Random Int       min=20        max=200
    ${body}                 Create Dictionary
    ...                     nome=${nome}
    ...                     preco=${preco} 
    ...                     descricao=${descricao}
    ...                     quantidade=${quantidade} 
    Set Test Variable       ${body}

POST Endpoint /produtos com autenticação
    ${header}               Create Dictionary       Authorization=${token}
    Body para cadastro de produto
    ${response}             POST On Session     serverest       /produtos     json=${body}     expected_status=any      headers=${header}
    Log To Console          Produto criado: ${body}
    Set Test Variable       ${header}
    Set Test Variable       ${response}

POST Endpoint /produtos sem autenticação
    Body para cadastro de produto
    ${response}             POST On Session     serverest       /produtos     json=${body}     expected_status=any
    Log To Console          Produto criado: ${body}
    Set Test Variable       ${response}

POST Endpoint /produtos com nome já utilizado
    POST Endpoint /produtos com autenticação
    ${nome_utilizado}       Set Variable        ${body["nome"]}
    Body para cadastro de produto
    Set To Dictionary       ${body}             nome=${nome_utilizado}
    ${response}             POST On Session     serverest       /produtos      json=${body}     expected_status=any     headers=${header}
    Log To Console          Produto com nome já utilizado: ${body}
    Set Test Variable       ${response}

Obter ID do produto
    Criar sessão e obter token
    POST Endpoint /produtos com autenticação
    ${id_produto}           Get From Dictionary       ${response.json()}      _id
    Set Test Variable      ${id_produto}



GET Endpoint /produtos
    ${id}                   Get From Dictionary     ${response.json()}     _id
    ${nome}                 Get From Dictionary     ${body}                nome
    ${preco}                Get From Dictionary     ${body}                preco
    ${descricao}            Get From Dictionary     ${body}                descricao
    ${quantidade}           Get From Dictionary     ${body}                quantidade
    ${parameters}           Create Dictionary       
    ...                     _id=${id} 
    ...                     nome=${nome}
    ...                     preco=${preco} 
    ...                     descricao=${descricao} 
    ...                     quantidade=${quantidade}
    ${response}             GET On Session      serverest      /produtos       expected_status=any       params=${parameters}
    Log to Console          Produto de id ${_id}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /produtos/{_id}
    ${id}                   Get From Dictionary     ${response.json()}     _id
    ${response}             GET On Session      serverest      /produtos/${id}        expected_status=any
    Log to Console          Produto de id ${_id}: ${response.content}
    Set Test Variable       ${response}

#Carrinhos
Body para cadastro de carrinho
    Obter ID do produto
    ${quantidade}           FakerLibrary.Random Int       min=1        max=50
    ${produto1}             Create Dictionary
    ...                     idProduto=${id_produto}
    ...                     quantidade=${quantidade}
    @{lista_produtos}       Create List             ${produto1}
    ${body}                 Create Dictionary       produtos=${lista_produtos}
    Set Test Variable       ${body}
    Set Test Variable       ${token}

POST Endpoint /carrinhos
    Body para cadastro de carrinho
    ${header}               Create Dictionary       Authorization=${token}
    ${response}             POST On Session     serverest       /carrinhos    json=${body}     expected_status=any      headers=${header}     
    Log To Console          Carrinho criado: ${body}
    Set Test Variable       ${response}



GET Endpoint /carrinhos
    ${id}                   Get From Dictionary     ${response.json()}      _id
    GET Endpoint /carrinhos/{_id}
    ${preco_total}          Get From Dictionary     ${response.json()}      precoTotal
    ${quantidade_total}     Get From Dictionary     ${response.json()}      quantidadeTotal
    ${id_usuario}           Get From Dictionary     ${response.json()}      idUsuario
    ${parameters}           Create Dictionary       
    ...                     _id=${id}
    ...                     precoTotal=${preco_total} 
    ...                     quantidadeTotal=${quantidade_total}
    ...                     idUsuario=${id_usuario}
    ${response}             GET On Session      serverest      /carrinhos       expected_status=any       params=${parameters}
    Log to Console          Carrinho de id ${_id}: ${response.content}
    Set Test Variable       ${response}

GET Endpoint /carrinhos/{_id}
    ${id}                   Get From Dictionary     ${response.json()}     _id
    ${response}             GET On Session      serverest      /carrinhos/${id}        expected_status=any
    Log to Console          Carrinho de id ${_id}: ${response.content}
    Set Test Variable       ${response}