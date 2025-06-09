*** Keywords ***
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