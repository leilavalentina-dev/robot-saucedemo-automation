*** Settings ***
Documentation       Suite de testes para o sistema de vendas Sauce Demo.
Resource            ../resources/resources.robot
Test Setup          Abrir Navegador
Test Teardown       Fechar Navegador

*** Variables ***
${USER_STANDARD}        standard_user
${USER_GLITCH}          performance_glitch_user
${PASSWORD}             secret_sauce

*** Test Cases ***
Cenario 1: Compra Completa com Usuario Padrao
    [Documentation]    Realiza o login, adiciona 2 produtos, remove 1 e finaliza a compra.
    Realizar Login    ${USER_STANDARD}    ${PASSWORD}
    Adicionar Produto Ao Carrinho Por Indice    2
    Adicionar Produto Ao Carrinho Por Indice    3
    Remover Produto Do Carrinho Por Indice    2
    Acessar Carrinho
    Finalizar Pedido

Cenario 2: Compra Completa com Usuario Lento
    [Documentation]    Realiza o login com o usuario que simula lentidao, adiciona 2 produtos, remove 1 e finaliza a compra.
    Realizar Login    ${USER_GLITCH}    ${PASSWORD}
    Adicionar Produto Ao Carrinho Por Indice    2
    Adicionar Produto Ao Carrinho Por Indice    3
    Remover Produto Do Carrinho Por Indice    2
    Acessar Carrinho
    Finalizar Pedido

Cenario 3: Tentativa de Finalizacao de Pedido com Carrinho Vazio
    [Documentation]    Realiza o login, acessa o carrinho vazio e tenta finalizar o pedido.
    Realizar Login    ${USER_STANDARD}    ${PASSWORD}
    Acessar Carrinho
    # A tentativa de finalizar o pedido com carrinho vazio implica em seguir o fluxo de checkout
    # O site permite ir para o checkout mesmo com o carrinho vazio, mas o teste deve validar o fluxo.
    Finalizar Pedido
    # Nota: O site permite a finalizacao, mas o carrinho estara vazio. O teste valida o fluxo de navegacao.
