*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${URL}                  https://www.saucedemo.com/
${BROWSER}              Chrome
${USERNAME_FIELD}       id=user-name
${PASSWORD_FIELD}       id=password
${LOGIN_BUTTON}         id=login-button
${CART_BUTTON}          id=shopping_cart_container
${CHECKOUT_BUTTON}      id=checkout
${CONTINUE_BUTTON}      id=continue
${FINISH_BUTTON}        id=finish
${FIRST_NAME_FIELD}     id=first-name
${LAST_NAME_FIELD}      id=last-name
${POSTAL_CODE_FIELD}    id=postal-code
${PRODUCT_LIST}         css=.inventory_item
${ADD_TO_CART_BUTTON}   xpath=//button[text()='Add to cart']
${REMOVE_BUTTON}        xpath=//button[text()='Remove']
${CART_ITEM}            css=.cart_item

*** Keywords ***
Abrir Navegador
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    
    # Adiciona argumentos para desativar avisos de segurança e pop-ups de senha
    Call Method    ${chrome_options}    add_argument    --disable-save-password-bubble
    Call Method    ${chrome_options}    add_argument    --disable-infobars
    Call Method    ${chrome_options}    add_argument    --disable-notifications
    
    # Desativa o gerenciador de senhas do perfil
    ${prefs}=    Create Dictionary    credentials_enable_service=${False}    profile.password_manager_enabled=${False}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Fechar Navegador
    Close Browser

Realizar Login
    [Arguments]    ${username}    ${password}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Text    ${PASSWORD_FIELD}    ${password}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${PRODUCT_LIST}

Adicionar Produto Ao Carrinho Por Indice
    [Arguments]    ${index}
    # O índice é 1-based no XPath
    ${locator}=    Set Variable    (//div[@class='inventory_item'])[${index}]//button[text()='Add to cart']
    Click Button    ${locator}

Remover Produto Do Carrinho Por Indice
    [Arguments]    ${index}
    # O índice é 1-based no XPath
    ${locator}=    Set Variable    (//div[@class='inventory_item'])[${index}]//button[text()='Remove']
    Click Button    ${locator}

Acessar Carrinho
    Click Element    ${CART_BUTTON}
    Wait Until Page Contains Element    ${CHECKOUT_BUTTON}

Finalizar Pedido
    Click Button    ${CHECKOUT_BUTTON}
    Preencher Informacoes Pessoais
    Click Button    ${CONTINUE_BUTTON}
    Wait Until Page Contains    Checkout: Overview
    Click Button    ${FINISH_BUTTON}
    Wait Until Page Contains    Checkout: Complete!

Preencher Informacoes Pessoais
    Input Text    ${FIRST_NAME_FIELD}    Teste
    Input Text    ${LAST_NAME_FIELD}    Robot
    Input Text    ${POSTAL_CODE_FIELD}    12345
