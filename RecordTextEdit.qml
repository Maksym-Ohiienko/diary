import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Item {
    id: root

    property int   maximumTextLength: 50
    property alias text: titleRecordEdit.text
    property alias textFont: titleRecordEdit.font
    property alias textColor: titleRecordEdit.color
    property alias placeHolderText: titleRecordPlaceholder.text
    property alias placeHolderFont: titleRecordPlaceholder.font
    property alias border: titleRecordBackground.border
    property alias backgroundColor: titleRecordBackground.color
    property alias selectionColor: titleRecordEdit.selectionColor

    signal textLengthChanged()
    signal enterReleased()

    Rectangle {
        id: titleRecordBackground
        color: "white"
        border.color: "skyblue"
        border.width: 5
        radius: 20
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        TextEdit {
            id: titleRecordEdit

            clip: true
            font.pixelSize: 24
            font.family: "Helvetica"
            wrapMode: TextEdit.Wrap
            selectByMouse: true
            selectionColor: "lightblue"
            color: "cadetblue"
            padding: 10
            anchors.fill: parent
            anchors.margins: 10

            onLengthChanged: {
                root.textLengthChanged()
            }

            onTextChanged: {
                if (titleRecordEdit.text.length > maximumTextLength) {
                    titleRecordEdit.text = titleRecordEdit.text.slice(0, maximumTextLength)
                    titleRecordEdit.cursorPosition = titleRecordEdit.text.length
                }
            }

            // Placeholder
            Text {
                id: titleRecordPlaceholder
                font.pixelSize: 24
                font.family: "Helvetica"
                color: parent.color
                visible: titleRecordEdit.text.length === 0

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
            }
            Keys.onReleased: (event) => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    titleRecordEdit.text = titleRecordEdit.text.substring(0, titleRecordEdit.text.length - 1)
                    root.enterReleased()
                }
            }
        }
    }
}
