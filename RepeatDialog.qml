import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Dialog {
    id: root

    property string selectedRepeatModeStr: "Empty"

    width: 400
    height: 200
    modal: Qt.WindowModal

    signal acceptedSet()
    signal rejectedSet()

    header: Rectangle {
        width: parent.width
        height: 60
        color: "lightblue"
        border.color: "gray"

        Text {
            text: "Set as repeating task"
            font.pixelSize: 24
            color: "white"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 15
        }

        DiarySwitch {
            id: isTaskRepeating

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 10

            onClicked: {
                repeatTaskTemplates.selectedIndex = isTaskRepeating.checked ? repeatTaskTemplates.currentIndex : -1
            }
        }
    }

    PathView {
        id: repeatTaskTemplates

        model: [ "Monthly", "Daily", "Weekly", "Hour", "Annually" ]
        property int selectedIndex: -1

        anchors.fill: parent
        anchors.margins: 10

        clip: true

        delegate: RoundButton {
            id: pathBtn

            width: pathTextMetrics.width   + 20
            height: pathTextMetrics.height + 15

            text: modelData
            buttonColor: parent.selectedIndex === index ? "blue" : "skyblue"
            textColor:   parent.selectedIndex === index ? "skyblue" : "white"
            font.pixelSize: 16
            font.bold: parent.selectedIndex === index

            TextMetrics {
                id: pathTextMetrics
                text: pathBtn.text
                font.pixelSize: pathBtn.font.pixelSize
            }

            onClicked: {
                parent.selectedIndex = index
                parent.currentIndex = index
                isTaskRepeating.checked = true
            }
        }

        path: Path {
            startX: 40
            startY: 35
            PathLine { x: repeatTaskTemplates.width + 30; y: 35 }
        }

        pathItemCount: 4
    }

    footer: Item {

        id: footerRow
        height: 40
        width: root.width

        RoundButton {
            text: "CANCEL"
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
                root.rejectedSet()
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

                selectedRepeatModeStr = isTaskRepeating.checked ? repeatTaskTemplates.model[repeatTaskTemplates.selectedIndex] : "Empty"

                root.acceptedSet()
            }
        }
    }

    onVisibleChanged: {

        if (!visible) return

        if (recordRepeatMode !== "Empty") {

            repeatTaskTemplates.selectedIndex = repeatTaskTemplates.model.indexOf(recordRepeatMode)
            repeatTaskTemplates.currentIndex = repeatTaskTemplates.selectedIndex
            isTaskRepeating.checked = true

        }
        else {
            repeatTaskTemplates.selectedIndex = -1
            isTaskRepeating.checked = false
        }
    }
}
