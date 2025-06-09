*** Keywords ***
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