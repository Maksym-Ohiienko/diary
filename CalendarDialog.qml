import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Dialog {
    id: root

    property string selectedDateStr: "Empty"

    width: 400
    height: 500
    modal: Qt.WindowModal

    signal acceptedSelect()
    signal rejectedSelect()

    header: Rectangle {
        width: parent.width
        height: 40
        color: "lightblue"
        border.color: "gray"

        Text {
            text: "Select Deadline Day"
            font.pixelSize: 21
            font.bold: false
            color: "white"
            anchors.centerIn: parent
        }
    }

    DiaryCalendar {
        id: dialogCalendar
        dialogXPos: 40
        dialogYPos: 0
        selectionColor: "lightblue"
        theme: ""

        anchors.fill: parent
        anchors.bottomMargin: footerRow.height

        onSelectedDateChanged: {
            if (!dialogCalendar.isSelectedDateCorrect()) {
                repeaterView.selectedIndex = 0
            } else {
                var template = repeaterView.getTemplateByDate(selectedDate)
                var index = repeaterView.model.indexOf(template)

                repeaterView.selectedIndex = index !== 0 ? index : -1
            }
        }
    }

    Grid {
        id: gridLayout

        anchors.top: dialogCalendar.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: dialogCalendar.horizontalCenter

        rows: Math.ceil(repeaterView.model.count / gridLayout.columns)
        columns: 3
        spacing: 10

        Repeater {
            id: repeaterView
            property int selectedIndex: 1
            model: ["No date", "Today", "Tomorrow", "A week later", "A month later", "A year later"] // templates for typical dates

            delegate: RoundButton {
                id: repeaterDelegate
                width: textMetrics.width + 20
                height: textMetrics.height + 5
                text: modelData
                buttonColor: repeaterView.selectedIndex === index ? "skyblue" : "lightblue"
                textColor: "white"
                font.pixelSize: 16

                TextMetrics {
                    id: textMetrics
                    text: repeaterDelegate.text
                    font.pixelSize: repeaterDelegate.font.pixelSize
                }

                onClicked: {
                    repeaterView.selectedIndex = index
                    var newDate = repeaterView.getDateByTemplate(modelData)
                    if (newDate !== 0) {
                        dialogCalendar.selectedDate = newDate
                    }
                    else {
                        dialogCalendar.selectedDate = new Date(2100, 2, 3) // my error date
                    }
                }
            }

            function getDateByTemplate(template) {

                var currDate = new Date()

                if (template === "Today") {
                    return currDate
                }
                else if (template === "Tomorrow") {
                    currDate.setDate(currDate.getDate() + 1)
                    return currDate
                }
                else if (template === "A week later") {
                    currDate.setDate(currDate.getDate() + 7)
                    return currDate
                }
                else if (template === "A month later") {
                    currDate.setMonth(currDate.getMonth() + 1)
                    return currDate
                }
                else if (template === "A year later") {
                    currDate.setFullYear(currDate.getFullYear() + 1)
                    return currDate
                }
                else { return 0 }
            }
            function getTemplateByDate(date) {

                var currDate = new Date()

                if (date.toDateString() === currDate.toDateString()) {
                    return "Today"
                }
                currDate.setDate(currDate.getDate() + 1)
                if (date.toDateString() === currDate.toDateString()) {
                    return "Tomorrow"
                }

                currDate = new Date()
                currDate.setDate(currDate.getDate() + 7)

                if (date.toDateString() === currDate.toDateString()) {
                    return "A week later"
                }

                currDate = new Date()
                currDate.setMonth(currDate.getMonth() + 1)

                if (date.toDateString() === currDate.toDateString()) {
                    return "A month later"
                }

                currDate = new Date()
                currDate.setFullYear(currDate.getFullYear() + 1)

                if (date.toDateString() === currDate.toDateString()) {
                    return "A year later"
                }
                else { return "No date" }
            }
        }
    }

    footer: RowLayout {

        id: footerRow
        height: 60
        width: parent.width

        RoundButton {
            text: "CANCEL"
            font.pixelSize: 18
            buttonColor: "transparent"
            textColor: "skyblue"
            opacity: 0.8

            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: root.width / 3
            Layout.margins: 5
            height: footerRow.height - 20

            onClicked: {
                root.visible = false
                root.rejectedSelect()
            }
        }

        RoundButton {
            text: "OK"
            font.pixelSize: 18
            font.bold: true
            buttonColor: "transparent"
            textColor: "skyblue"

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: root.width / 3
            Layout.margins: 5
            height: footerRow.height - 20

            onClicked: {
                root.visible = false

                selectedDateStr = repeaterView.selectedIndex === 0 ? "Empty" : Qt.formatDate(dialogCalendar.selectedDate, "yyyy/MM/dd")

                root.acceptedSelect()
            }
        }
    }

    onVisibleChanged: {

        if (!visible) return

        if (recordDate.toDateString() !== new Date(2100, 2, 3).toDateString()) {
            dialogCalendar.selectedDate = recordDate
        }
    }
}
