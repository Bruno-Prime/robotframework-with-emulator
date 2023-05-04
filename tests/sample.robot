*** Settings ***
# Resource        ../resources/main.robot

Library     String
Library     Collections
Library     DateTime
Library     AppiumLibrary    timeout=15
Library     PerfectoLibrary    Sample Contador    1.0

Test Setup      New Session    ${SESSION_TYPE}


*** Variables ***
&{elements}
...                         first_input=app.example.butomo.sampleapplication:id/first_input
...                         second_input=app.example.butomo.sampleapplication:id/second_input
...                         btn_calculate=app.example.butomo.sampleapplication:id/btn_calculate
...                         lbl_result=app.example.butomo.sampleapplication:id/result

${SESSION_TYPE}             local
${PERFECTO_CLOUD_NAME}      demo
${PERFECTO_SECRET_TOKEN}


*** Test Cases ***
Sample Test
    [Tags]    poc

    Wait Until Element Is Visible    ${elements.first_input}    30
    Capture Page Screenshot
    Input Text    ${elements.first_input}    10
    Capture Page Screenshot
    Input Text    ${elements.second_input}    25
    Capture Page Screenshot
    Click Element    ${elements.btn_calculate}

    Sleep    0.5

    ${text}    Get Text    ${elements.lbl_result}
    Should Be Equal    ${text}    35
    Capture Page Screenshot


*** Keywords ***
New Session
    [Arguments]    ${session_type}=local

    # Normalizar input
    ${session_type}    Set Variable    ${session_type.lower()}

    IF    $session_type == 'local'
        Open Application
        ...    remote_url=http://127.0.0.1:4723/wd/hub
        ...    autoGrantPermissions=${True}
        ...    automationName=UiAutomator2
        ...    platformName=Android
        ...    app=${CURDIR}/../resources/app/sample_apk_debug.apk
    ELSE
        Open Application
        ...    remote_url=https://${PERFECTO_CLOUD_NAME}.perfectomobile.com/nexperience/perfectomobile/wd/hub
        ...    perfecto:securityToken=${PERFECTO_SECRET_TOKEN}
        ...    perfecto:takesScreenshot=${True}
        ...    perfecto:platformName=Android
        # ...    perfecto:deviceName=RFCT11CFZSM
        ...    perfecto:autoInstrument=${True}
        ...    enableAppiumBehavior=${True}
        ...    disableWindowAnimation=${True}
        ...    skipDeviceInitialization=${True}
        ...    autoGrantPermissions=${True}
        ...    automationName=Appium
        ...    platformName=Android
        ...    app=PRIVATE:contador_sample.apk
    END
