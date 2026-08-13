import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1366
    height: 768
    color: "#0d1117"

    property color accent: "#39ff5c"
    property color textCol: "#c9d1d9"
    property color dimCol: "#6e7681"
    property color panelBg: "#04120c"

    Image {
        id: background
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
    }

    // ---- painel central de login ----
    Rectangle {
        id: loginPanel
        width: 340
        height: 300
        anchors.centerIn: parent
        color: panelBg
        border.color: accent
        border.width: 2
        radius: 6

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 14

            Text {
                text: "ACCESS // Q464B.sh"
                color: accent
                font.family: "JetBrains Mono"
                font.pixelSize: 15
                font.bold: true
            }

            Rectangle { width: parent.width; height: 1; color: "#1c3a28" }

            Text {
                text: "usuario:"
                color: dimCol
                font.family: "JetBrains Mono"
                font.pixelSize: 11
            }

            TextField {
                id: userField
                width: parent.width
                height: 34
                text: userModel.lastUser
                font.family: "JetBrains Mono"
                font.pixelSize: 12
                color: textCol
                selectByMouse: true
                background: Rectangle {
                    color: "#0d1117"
                    border.color: accent
                    border.width: 1
                    radius: 3
                }
                KeyNavigation.tab: passwordField
            }

            Text {
                text: "senha:"
                color: dimCol
                font.family: "JetBrains Mono"
                font.pixelSize: 11
            }

            TextField {
                id: passwordField
                width: parent.width
                height: 34
                echoMode: TextInput.Password
                font.family: "JetBrains Mono"
                font.pixelSize: 12
                color: textCol
                selectByMouse: true
                background: Rectangle {
                    color: "#0d1117"
                    border.color: accent
                    border.width: 1
                    radius: 3
                }
                onAccepted: sddm.login(userField.text, passwordField.text, sessionCombo.currentIndex)
            }

            Row {
                width: parent.width
                spacing: 12

                Button {
                    text: "entrar"
                    width: 100
                    height: 30
                    onClicked: sddm.login(userField.text, passwordField.text, sessionCombo.currentIndex)
                    contentItem: Text {
                        text: parent.text
                        color: accent
                        font.family: "JetBrains Mono"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: "#0d1117"
                        border.color: accent
                        border.width: 2
                        radius: 4
                    }
                }

                ComboBox {
                    id: sessionCombo
                    width: parent.width - 112
                    height: 30
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    model: sessionModel
                    textRole: "name"
                    currentIndex: sessionModel.lastIndex
                    background: Rectangle {
                        color: "#0d1117"
                        border.color: accent
                        border.width: 1
                        radius: 3
                    }
                    contentItem: Text {
                        text: sessionCombo.displayText
                        color: textCol
                        font.family: "JetBrains Mono"
                        font.pixelSize: 11
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 8
                    }
                }
            }
        }
    }

    // ---- relógio no topo ----
    Text {
        id: clock
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
        color: accent
        font.family: "JetBrains Mono"
        font.pixelSize: 28
        font.bold: true
        text: Qt.formatDateTime(new Date(), "HH:mm")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
        }
    }

    Text {
        anchors.top: clock.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4
        color: dimCol
        font.family: "JetBrains Mono"
        font.pixelSize: 12
        text: Qt.formatDateTime(new Date(), "dddd, dd/MM/yyyy")
    }

    // ---- mensagem de erro de login ----
    Text {
        id: errorMsg
        anchors.top: loginPanel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
        color: "#ff5555"
        font.family: "JetBrains Mono"
        font.pixelSize: 12
        text: ""
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMsg.text = "acesso negado — senha incorreta"
            passwordField.text = ""
        }
    }

    // ---- botões de energia no canto inferior direito ----
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 12

        Button {
            text: "reiniciar"
            width: 90
            height: 28
            visible: sddm.canReboot
            onClicked: sddm.reboot()
            contentItem: Text {
                text: parent.text
                color: dimCol
                font.family: "JetBrains Mono"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#0d1117"
                border.color: dimCol
                border.width: 1
                radius: 4
            }
        }

        Button {
            text: "desligar"
            width: 90
            height: 28
            visible: sddm.canPowerOff
            onClicked: sddm.powerOff()
            contentItem: Text {
                text: parent.text
                color: dimCol
                font.family: "JetBrains Mono"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#0d1117"
                border.color: dimCol
                border.width: 1
                radius: 4
            }
        }
    }

    Component.onCompleted: {
        userField.forceActiveFocus()
    }
}
