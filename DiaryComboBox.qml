import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

ComboBox {
    id: root

    property color backgroundColor: "lightblue"
    property color borderColor:     "skyblue"
    property color itemColor:       "cadetblue"
    property color selectionColor:  "skyblue"
    property color indicatorColor:  "deepskyblue"

    property bool modelIsJson: false

    width: displayText.paintedWidth + 40
    height: 30

    delegate: Rectangle {
        width: root.width
        height: root.height
        color: "transparent"

        RoundButton {
            id: delegate
            text: root.modelIsJson ? root.model[index].category : modelData
            font.pixelSize: 16
            font.family: "Helvetica"
            textColor: root.itemColor
            buttonColor: root.currentIndex === index ? root.selectionColor : "transparent"
            width: parent.width
            height: parent.height
            x: 20

            onClicked: {
                root.currentIndex = index
                root.popup.close()
            }
        }
    }

    background: Rectangle {
        implicitWidth: root.width
        implicitHeight: root.implicitContentHeight
        color: root.backgroundColor
        radius: 10
    }

    indicator: Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        color: "transparent"

        Text {
            text: popupCb.opened ? "▼" : "◄"
            anchors.centerIn: parent
            color: root.indicatorColor
        }
    }

    contentItem: Item {
        width: root.width
        height: root.height

        Text {
            id: displayText
            anchors.centerIn: parent
            text: root.modelIsJson ? (root.model[root.currentIndex] ? root.model[root.currentIndex].category : "Empty") : root.displayText
            font.pixelSize: 18
            font.family: "Helvetica"
            color: root.itemColor
        }
    }

    popup: Popup {
        id: popupCb
        y: root.height
        width: root.width * 2
        implicitHeight: contentHeight + 20

        contentItem: ListView {
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: root.backgroundColor
            border.color: root.borderColor
            radius: 10
        }
    }
}
