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