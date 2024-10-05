import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Dialog {
    id: root

    property string selectedTimeStr:        "Empty"
    property string selectedReminderStr:    "Empty"

    width: 400
    height: 500
    modal: Qt.WindowModal

    signal acceptedSelect()
    signal rejectedSelect()

    Component {
        id: tumblerDelegate

        RoundButton {
            id: tumblerBtn
            width: parent.width
            height: tumblerTextMetrics.height
            text: modelData
            buttonColor: parent.currentIndex === index ? "skyblue" : "transparent"
            textColor:   parent.currentIndex === index ? "white" : "black"
            font.pixelSize: 24

            TextMetrics {
                id: tumblerTextMetrics
                text: tumblerBtn.text
                font.pixelSize: tumblerBtn.font.pixelSize
            }
        }
    }

    header: Rectangle {
        width: parent.width
        height: 40
        color: "lightblue"
        border.color: "gray"

        Text {
            text: "Select Deadline Time"
            font.pixelSize: 21
            color: "white"
            anchors.centerIn: parent
        }
    }


    Item {
        anchors.fill: parent

        Item {
            id: timeEdit
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter

            Text {
                id: timeText
                text: "Enter time"
                font.pixelSize: 21
                anchors.top: timeEdit.top
                anchors.left: hoursTumbler.left
                anchors.leftMargin: 12
                anchors.right: timeEdit.right
            }

            Tumbler {
                id: hoursTumbler
                width: 50
                height: 150
                anchors.top: timeText.bottom
                anchors.topMargin: 10
                anchors.left: timeEdit.left

                model: ListModel {
                    Component.onCompleted: {
                        for (var i = 0; i < 24; i++) {
                            append({"value": i < 10 ? "0" + i : i.toString()})
                        }
                    }
                }

                onCountChanged: {
                    if (hoursTumbler.count > 1 && recordTime !== "Empty") {
                        hoursTumbler.currentIndex = parseInt(recordTime.split(":")[0], 10)
                    }
                }

                onCurrentIndexChanged: {
                    repeaterView.updateTemplate()
                }

                delegate: tumblerDelegate
            }

            Text {
                id: colon
                text: ":"
                font.pixelSize: 21
                font.bold: true
                anchors.left: hoursTumbler.right
                anchors.leftMargin: 5
                anchors.verticalCenter: hoursTumbler.verticalCenter
            }

            Tumbler {
                id: minutesTumbler
                width: 50
                height: 150
                anchors.top: hoursTumbler.top
                anchors.left: colon.right
                anchors.leftMargin: 5
                anchors.verticalCenter: hoursTumbler.verticalCenter

                model: ListModel {
                    Component.onCompleted: {
                        for (var i = 0; i < 60; i++) {
                            append({"value": i < 10 ? "0" + i : i.toString()})
                        }
                    }
                }

                onCountChanged: {
                    if (minutesTumbler.count > 1 && recordTime !== "Empty") {
                        minutesTumbler.currentIndex = parseInt(recordTime.split(":")[1], 10)
                    }
                }

                onCurrentIndexChanged: {
                    repeaterView.updateTemplate()
                }

                delegate: tumblerDelegate
            }

            Text {
                text: "h."
                font.pixelSize: 18

                anchors.left: hoursTumbler.left
                anchors.leftMargin: 12
                anchors.top: hoursTumbler.bottom
                anchors.topMargin: 10
            }
            Text {
                text: "min."
                font.pixelSize: 18

                anchors.left: minutesTumbler.left
                anchors.leftMargin: 12
                anchors.top: minutesTumbler.bottom
                anchors.topMargin: 10
            }
        }

        Text {
            id: reminderText
            text: "Reminder"
            font.pixelSize: 21

            anchors.top: parent.top
            anchors.rightMargin: 12
            anchors.right: parent.right
        }

        DiarySwitch {
            id: haveReminder

            enabled: toolBar.reminderOn

            anchors.top: reminderText.bottom
            anchors.topMargin: 10
            anchors.right: reminderText.right

            onEnabledChanged: {
                if (!enabled) {
                    checked = false
                }
            }
        }

        Grid {
            id: gridLayout

            anchors.bottom: parent.bottom
            anchors.left: parent.left

            rows: Math.ceil(repeaterView.model.count / columns)
            columns: 4
            spacing: 10

            Repeater {
                id: repeaterView
                property int selectedIndex: -1
                model: ["No time", "07:00", "08:00", "09:00", "12:00", "14:00", "16:00", "18:00", "22:00"] // templates for typical times

                delegate: RoundButton {
                    id: repeaterDelegate
                    width: textMetrics.width + 40
                    height: textMetrics.height + 10
                    text: modelData
                    buttonColor: repeaterView.selectedIndex === index ? "blue" : "lightblue"
                    textColor: repeaterView.selectedIndex === index ? "skyblue" : "white"
                    font.pixelSize: 18

                    TextMetrics {
                        id: textMetrics
                        text: repeaterDelegate.text
                        font.pixelSize: repeaterDelegate.font.pixelSize
                    }

                    onClicked: {
                        repeaterView.selectedIndex = index

                        if (modelData !== "No time") {
                            var hours = modelData.split(":")[0]
                            minutesTumbler.currentIndex = 0;

                            Qt.callLater(function() {
                                hoursTumbler.currentIndex = parseInt(hours, 10);
                            });
                        }
                    }
                }

                function getTemplateByHours(hours) {

                    for (var i = 1; i < repeaterView.count; ++i) {

                        var currHours = parseInt(repeaterView.model[i].split(":")[0], 10)

                        if (currHours === hours) {
                            return i;
                        }
                    }
                    return -1;
                }

                function updateTemplate() {
                    if (minutesTumbler.currentIndex === 0) {
                        var indexTemplate = repeaterView.getTemplateByHours(hoursTumbler.currentIndex)
                        repeaterView.selectedIndex = indexTemplate
                    }
                    else {
                        repeaterView.selectedIndex = -1
                    }
                }
            }
        }
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
                root.rejectedSelect()
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

                root.selectedTimeStr = repeaterView.selectedIndex === 0
                    ? "Empty"
                    : getTimeString(hoursTumbler.currentIndex, minutesTumbler.currentIndex);

                if (repeaterView.selectedIndex === 0 || !toolBar.reminderOn || !haveReminder.checked) {
                    root.selectedReminderStr = "Empty"
                }
                else if (minutesTumbler.currentIndex >= 5) {
                    root.selectedReminderStr = getTimeString(hoursTumbler.currentIndex, minutesTumbler.currentIndex - 5);
                }
                else if (hoursTumbler.currentIndex > 0){
                    root.selectedReminderStr = getTimeString(hoursTumbler.currentIndex - 1, minutesTumbler.currentIndex + 60 - 5);
                }
                else {
                    root.selectedReminderStr = getTimeString(23, minutesTumbler.currentIndex + 60 - 5);
                }

                root.acceptedSelect()
            }

            function getTimeString(hoursIndex, minutesIndex) {
                return hoursTumbler.model.get(hoursIndex).value + ":" + minutesTumbler.model.get(minutesIndex).value;
            }
        }
    }

    onVisibleChanged: {

        if (!visible) return

        if (recordTime !== "Empty") {

            hoursTumbler.currentIndex = parseInt(recordTime.split(":")[0], 10)
            minutesTumbler.currentIndex = parseInt(recordTime.split(":")[1], 10)
        }

        haveReminder.checked = recordReminderTime !== "Empty"
    }
}
