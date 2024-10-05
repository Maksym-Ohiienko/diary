import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Rectangle {
    id: root

    property alias image: image.source
    property alias imageWidth: image.width
    property alias imageHeight: image.height
    property alias title: title.text
    property alias infoText: information.text
    property alias font: information.font
    property alias containsMouse: button.containsMouse

    property color infoTextColor: "skyblue"

    signal clicked()

    width: mainWindow.width - 20
    height: 50
    border.color: root.enabled ? "skyblue" : "gray"
    border.width: 3
    radius: 10
    color: root.enabled ? "white" : "lightgray"

    Image {
        id: image
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10

        width: 32
        height: 32
    }
    Text {
        id: title
        anchors.left: image.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10

        font.family: "Helvetica"
        font.pixelSize: 16
        color: root.enabled ? "cadetblue" : "gray"
    }
    Text {
        id: information
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10

        font.family: "Helvetica"
        font.pixelSize: 16
        font.bold: true
        color: root.enabled ? root.infoTextColor : "gray"
    }
    RoundButton {
        id: button
        buttonColor: "transparent"
        anchors.fill: parent

        onClicked: {
            root.clicked()
        }
    }
}
