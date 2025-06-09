*** Keywords ***
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