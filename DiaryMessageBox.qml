import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import "."

Dialog {
    id: root

    width: 300
    height: 200
    modal: Qt.WindowModal

    property alias  titleText: headerText.text
    property alias  messageText: message.text
    property alias  messageTextFont: message.font
    property bool   cancelEnabled: false

    signal accepted()
    signal rejected()

    background: Rectangle {
        radius: 20
        border.color: "skyblue"
        border.width: 3
        color: "white"
    }

    header: Rectangle {
        width: parent.width
        height: 60
        color: "lightblue"
        opacity: 0.6
        border.color: "skyblue"
        radius: 20

        Text {
            id: headerText
            font.pixelSize: 24
            font.bold: true
            color: "skyblue"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 15
        }
    }

    Text {
        id: message
        font.pixelSize: 21
        font.bold: true
        color: "lightblue"
        anchors.centerIn: parent
    }

    footer: Item {

        id: footerRow
        height: 40
        width: root.width

        RoundButton {
            text: "CANCEL"
            visible: root.cancelEnabled
            font.pixelSize: 18
            buttonColor: "transparent"
            textColor: "skyblue"
            opacity: 0.8

            anchors.right: okBtn.left
            anchors.rightMargin: 10
            anchors.verticalCenter: okBtn.verticalCenter

            width: 100
            height: footerRow.height / 2

            onClicked: {
                root.visible = false
                root.rejected()
            }
        }

        RoundButton {
            id: okBtn
            text: "OK"
            font.pixelSize: 18
            font.bold: true
            buttonColor: "transparent"
            textColor: "skyblue"

            anchors.right: footerRow.right
            anchors.rightMargin: 10
            anchors.bottom: footerRow.bottom
            anchors.bottomMargin: 15

            width: 100
            height: footerRow.height / 2

            onClicked: {
                root.visible = false

                root.accepted()
            }
        }
    }
}
