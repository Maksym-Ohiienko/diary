import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.1
import "."

ListView {
    id: root
    width: mainWindow.width
    height: mainWindow.height / 3

    property bool isListEnabled: true
    property bool isOnlyCompletedVisible: false

    clip: true

    function getDateTimeByRepeatMode(currentDate, currentTime, repeatMode) {

        var result = new Date(currentDate + " " + currentTime);

        switch (repeatMode) {
            case "Hour":
                result.setHours(result.getHours() + 1);
                break;
            case "Daily":
                result.setDate(result.getDate() + 1);
                break;
            case "Weekly":
                result.setDate(result.getDate() + 7);
                break;
            case "Monthly":
                result.setMonth(result.getMonth() + 1);
                break;
            case "Annually":
                result.setFullYear(result.getFullYear() + 1);
                break;
        }

        return result;
    }

    Timer {
        id: completeTimer
        interval: 1500

        onTriggered: {

            root.model.setData(root.model.index(root.currentIndex, mainModel.columnIndex("completed")), !root.isOnlyCompletedVisible, Qt.EditRole)

            var currRepeatMode = recordViewPage.getCurrentViewData(root, "repeatMode", "Empty")

            if (currRepeatMode !== "Empty") {

                root.model.setData(root.model.index(root.currentIndex, mainModel.columnIndex("repeatMode")), "Empty", Qt.EditRole)

                var newDateTime = getDateTimeByRepeatMode(recordViewPage.getCurrentViewData(root, "date", new Date()), recordViewPage.getCurrentViewData(root, "time", "Empty"), currRepeatMode);

                var newReminderTime = new Date(newDateTime);
                newReminderTime.setMinutes(newReminderTime.getMinutes() - 5);

                mainModel.addItem( recordViewPage.getCurrentViewData(root, "title", "Empty"),
                                   Qt.formatDate(newDateTime, "yyyy/MM/dd"),
                                   Qt.formatTime(newDateTime, "HH:mm"),
                                   toolBar.reminderOn ? Qt.formatTime(newReminderTime, "HH:mm") : "Empty",
                                   currRepeatMode,
                                   recordViewPage.getCurrentViewData(root, "category", "Empty"),
                                   recordViewPage.getCurrentViewData(root, "notes", ""),
                                   false)
            }

            mainModel.updateCounts()
            completeTimer.stop()
        }
    }

    Timer {
        id: reminderTimer
        interval: 60000
        running: true
        repeat: true

        onTriggered: {

            for (var i = 0; i < mainModel.rowCount(); ++i) {

                var recordCompleted = mainModel.data(mainModel.index(i, mainModel.columnIndex("completed")), Qt.DisplayRole)
                var recordReminder  = mainModel.data(mainModel.index(i, mainModel.columnIndex("reminder")), Qt.DisplayRole)
                var recordDate      = mainModel.data(mainModel.index(i, mainModel.columnIndex("date")), Qt.DisplayRole)
                var recordTime      = mainModel.data(mainModel.index(i, mainModel.columnIndex("time")), Qt.DisplayRole)
                var recordTitle     = mainModel.data(mainModel.index(i, mainModel.columnIndex("title")), Qt.DisplayRole)

                if (!recordCompleted && recordReminder) {

                    var reminderDate = new Date(recordDate)

                    if (recordReminder > recordTime) {
                        reminderDate.setDate(reminderDate.getDate() - 1);
                    }

                    var reminderDateTime = new Date(Qt.formatDate(reminderDate, "yyyy/MM/dd") + " " + recordReminder);
                    var now = new Date();

                    if (Qt.formatDate(reminderDateTime, "yyyy/MM/dd") === Qt.formatDate(now, "yyyy/MM/dd") &&
                            reminderDateTime.getHours() === now.getHours() && reminderDateTime.getMinutes() === now.getMinutes()) {

                        notificationManager.sendNotification("Reminder", "5 minutes to " + recordTitle);
                    }
                }
            }
        }
    }

    delegate: Item {
        id: listDelegate
        width: mainView.width
        height:  isCompleted === isOnlyCompletedVisible ? 80 : 0
        visible: isCompleted === isOnlyCompletedVisible

        property bool   isCompleted:    model.completed
        property color  buttonColor:    isCompleted ? "green" : "transparent"
        property string imageSource:    isCompleted ? "qrc:/images/RecordListPageIcons/checkMark.png" : ""
        property color  titleColor:     isCompleted ? "gray" : "cadetblue"
        property color  dateTimeColor:  isCompleted ? "lightgray" : "skyblue"

        Rectangle {

            width: parent.width
            height: parent.height
            border.color: "skyblue"
            border.width: 3
            radius: 5
            color: "white"

            anchors.fill: parent
            anchors.margins: 5

            RoundButton {
                id: toCompleteRecord
                size: parent.height / 2

                buttonColor: listDelegate.buttonColor
                border.width: isCompleted ? 1 : 2
                image: imageSource
                imageWidth: 24
                imageHeight: 24

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10

                SequentialAnimation {
                    id: swapStyleAnim
                    PropertyAnimation {
                        target: recordTitle
                        property: "font.strikeout"
                        to: !isCompleted
                        duration: 200
                        easing.type: Easing.InOutCubic
                    }
                    ColorAnimation {
                        target: toCompleteRecord
                        property: "buttonColor"
                        to: isCompleted ? "transparent" : "green"
                        duration: 700
                        easing.type: Easing.InOutCubic
                    }
                    PropertyAnimation {
                        target: toCompleteRecord
                        property: "image"
                        to: isCompleted ? "" : "qrc:/images/RecordListPageIcons/checkMark.png"
                        duration: 200
                        easing.type: Easing.InOutCubic
                    }
                }

                onClicked: {
                    if (!completeTimer.running) {
                        root.currentIndex = index

                        swapStyleAnim.start()
                        completeTimer.start()
                    }
                }
            }

            Text {
                id: recordTitle
                anchors.top: toCompleteRecord.top
                anchors.left: toCompleteRecord.right
                anchors.topMargin: 5
                anchors.leftMargin: 10
                font.strikeout: isCompleted

                text: model.title

                font.family: "Helvetica"
                font.pixelSize: 16
                color: titleColor
            }
            Text {
                id: recordDateTime
                anchors.top: recordTitle.bottom
                anchors.left: recordTitle.left
                anchors.margins: 3

                text: model.date + "  " + model.time

                font.family: "Helvetica"
                font.pixelSize: 10
                font.bold: true
                color: dateTimeColor
            }
            Image {
                id: itemHasReminderMark

                visible: !model.completed
                source: model.reminder ? "qrc:/images/RecordPageIcons/reminder.png" : "qrc:/images/MainPageIcons/reminderOff.png"
                width: 32
                height: 32

                anchors.right: itemRepeatedMark.left
                anchors.verticalCenter: itemRepeatedMark.verticalCenter
                anchors.rightMargin: 10
            }
            Image {
                id: itemRepeatedMark

                visible: model.repeatMode !== "Empty"
                source: "qrc:/images/RecordPageIcons/repeat.png"
                width: 32
                height: 32

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
            }

            MouseArea {
                id: mouseArea
                anchors.left: toCompleteRecord.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                enabled: isListEnabled

                hoverEnabled: true

                onEntered: { mouseArea.cursorShape = Qt.PointingHandCursor }
                onExited:  { mouseArea.cursorShape = Qt.ArrowCursor }

                onClicked: {
                    if (!completeTimer.running) { // We dont process clicks while the animation is running
                        root.currentIndex = index

                        recordViewPage.recordID                    = recordViewPage.getCurrentViewData(root, "ID", "0")
                        recordViewPage.recordTitle                 = recordViewPage.getCurrentViewData(root, "title", "Empty")
                        recordViewPage.recordDate                  = recordViewPage.getCurrentViewData(root, "date", new Date())
                        recordViewPage.recordTime                  = recordViewPage.getCurrentViewData(root, "time", "Empty")
                        recordViewPage.recordReminderTime          = recordViewPage.getCurrentViewData(root, "reminder", "Empty")
                        recordViewPage.recordRepeatMode            = recordViewPage.getCurrentViewData(root, "repeatMode", "Empty")
                        recordViewPage.recordCategory              = recordViewPage.getCurrentViewData(root, "category", "Empty")
                        recordViewPage.recordNotes                 = recordViewPage.getCurrentViewData(root, "notes", "")

                        mainView.push(recordViewPage)
                    }
                }
            }
        }
    }

    RecordPage {
        id: recordViewPage

        recordID                    : parseInt(getCurrentViewData(root, "ID", "0"))
        recordTitle                 : getCurrentViewData(root, "title", "Empty")
        recordDate                  : getCurrentViewData(root, "date", new Date())
        recordTime                  : getCurrentViewData(root, "time", "Empty")
        recordReminderTime          : getCurrentViewData(root, "reminder", "Empty")
        recordRepeatMode            : getCurrentViewData(root, "repeatMode", "Empty")
        recordCategory              : getCurrentViewData(root, "category", "Empty")
        recordNotes                 : getCurrentViewData(root, "notes", "")
    }
}
