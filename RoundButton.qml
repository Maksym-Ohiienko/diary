import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    id: root
    property int   size: 100
    property color buttonColor: "blue"
    property alias textColor: btnTxt.color
    property alias image: btnImage.source
    property alias imageHeight: btnImage.height
    property alias imageWidth: btnImage.width
    property alias text: btnTxt.text
    property alias font: btnTxt.font
    property alias backgroundOpacity: btnRect.opacity
    property alias border: btnRect.border
    property alias containsMouse: btnMouseArea.containsMouse

    signal clicked()

    width: size
    height: size

    Rectangle {
        id: btnRect
        anchors.fill: parent
        radius: size / 2
        color: btnMouseArea.containsPress ? Qt.lighter(root.buttonColor, 1.2) : root.buttonColor
        smooth: true
        border.width: 0

        MouseArea {
            id: btnMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                root.clicked()
            }
            onEntered: {
                btnMouseArea.cursorShape = Qt.PointingHandCursor
            }
            onExited: {
                btnMouseArea.cursorShape = Qt.ArrowCursor
            }
        }
    }
    Text {
        id: btnTxt
        anchors.centerIn: parent
        color: "white"
    }
    Image {
        id: btnImage
        anchors.centerIn: parent
        width: 48
        height: 48
    }

}
