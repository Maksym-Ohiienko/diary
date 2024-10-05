import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import "."

SimplePage {
    id: recordPage
    backgroundColor: "steelblue"
    property real dialogXPos: (recordPage.width - calendarDialog.width) / 2 - 20
    property real dialogYPos: -recordPage.height / 2

    property int        recordID: -1
    property alias      recordTitle: recordTitleEdit.text
    property date       recordDate: new Date(2100, 2, 3)
    property string     recordTime: "Empty"
    property string     recordReminderTime: "Empty"
    property string     recordRepeatMode: "Empty"
    property string     recordCategory: "Without category"
    property alias      recordNotes: recordNotesEdit.text

    readonly property bool isRecordPage: true

    function getCurrentViewData(view, columnName, defaultValue) {
        if (view.count > 0) {
            var data = view.model.data(view.model.index(view.currentIndex, mainModel.columnIndex(columnName)), Qt.DisplayRole);

            return data ? data.toString() : defaultValue;
        }
        return defaultValue;
    }

    function clearInputData() {
        recordPage.recordID             = -1
        recordPage.recordTitle          = ""
        recordPage.recordDate           = new Date(2100, 2, 3)
        recordPage.recordTime           = "Empty"
        recordPage.recordReminderTime   = "Empty"
        recordPage.recordRepeatMode     = "Empty"
        recordPage.recordCategory       = "Without category"
        recordPage.recordNotes          = ""

        recordTitleEdit.border.color        = "skyblue"
        dateBtn.border.color                = "skyblue"
        timeAndReminderBtn.border.color     = "gray"
        repeatBtn.border.color              = "gray"
    }

    onRecordCategoryChanged: {
        categoryCb.currentIndex = categoryCb.indexOfCategory(recordPage.recordCategory)
    }

    Item {
        id: recordPageContent
        anchors.fill: parent

        // ComboBox
        DiaryComboBox {
            id: categoryCb

            model: categoryManager ? categoryManager.categoryList() : []
            modelIsJson: true

            displayText: recordPage.recordCategory

            onCurrentIndexChanged: {
                recordPage.recordCategory = model[currentIndex].category
            }

            function indexOfCategory(category) {
                for (var i = 0; i < categoryCb.model.length; ++i) {
                    if (categoryCb.model[i].category === category) {
                        return i;
                    }
                }
                return -1;
            }

            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.topMargin: 10
            anchors.top: parent.top
        }

        RoundButton {
            id: removeBtn

            DiaryMessageBox {
                id: confirmRemoveDialog
                titleText: "Confirm the action"
                messageText: "Are you sure?"
                messageTextFont.pixelSize: 24
                cancelEnabled: true

                onAccepted: {
                    mainModel.removeItem(recordPage.recordID);
                    mainView.pop()
                }
            }

            size: 35
            visible: mainModel && mainModel.isRecordExists(recordPage.recordID)
            buttonColor: "darkred"
            image: "qrc:/images/RecordPageIcons/delete.png"
            imageHeight: 16
            imageWidth: 16

            anchors.top: categoryCb.top
            anchors.right: recordTitleEdit.right
            anchors.rightMargin: 10

            onClicked: {
                confirmRemoveDialog.x = -recordPage.width / 2 - confirmRemoveDialog.width / 3 + 5
                confirmRemoveDialog.y = confirmRemoveDialog.width / 2
                confirmRemoveDialog.open()
            }
        }

        // TextEdit
        RecordTextEdit {
            id: recordTitleEdit

            width: mainWindow.width

            placeHolderText: "Enter title here..."

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: categoryCb.bottom
            anchors.bottom: parent.verticalCenter
            anchors.margins: 10
        }

        PageButton {
            id: dateBtn
            image: "qrc:/images/RecordPageIcons/deadlineCalendar.png"
            title: "Deadline for the task"
            infoText: (Qt.formatDate(recordPage.recordDate, "yyyy/MM/dd") !== Qt.formatDate(new Date(2100, 2, 3), "yyyy/MM/dd")) ? Qt.formatDate(recordPage.recordDate, "yyyy/MM/dd") : "Empty"

            anchors.top: recordTitleEdit.bottom
            anchors.topMargin: 10
            anchors.left: recordTitleEdit.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 20

            onClicked: {
                calendarDialog.x = recordPage.dialogXPos
                calendarDialog.y = recordPage.dialogYPos
                calendarDialog.open()
            }

            CalendarDialog {
                id: calendarDialog

                onAcceptedSelect: {
                    recordPage.recordDate = calendarDialog.selectedDateStr !== "Empty" ? calendarDialog.selectedDateStr : new Date(2100, 2, 3)
                }
            }
        }

        PageButton {
            id: timeAndReminderBtn
            enabled: dateBtn.infoText !== "Empty"
            image: "qrc:/images/RecordPageIcons/time.png"
            title: "Time and Reminder"
            infoText: recordPage.recordTime

            anchors.top: dateBtn.bottom
            anchors.topMargin: 10
            anchors.left: dateBtn.left
            anchors.right: dateBtn.right

            onEnabledChanged: {
                if (!enabled) {
                    border.color = "gray"
                    recordPage.recordTime = "Empty"
                }
                else {
                    border.color = "skyblue"
                }
            }

            onClicked: {
                timeDialog.x = recordPage.dialogXPos
                timeDialog.y = recordPage.dialogYPos
                timeDialog.open()
            }

            TimeAndReminderDialog {
                id: timeDialog

                onAcceptedSelect: {
                    recordPage.recordTime = timeDialog.selectedTimeStr
                    recordPage.recordReminderTime = timeDialog.selectedReminderStr
                }
            }
        }

        PageButton {
            id: repeatBtn
            enabled: dateBtn.infoText !== "Empty"
            image: "qrc:/images/RecordPageIcons/repeat.png"
            title: "Repeat task"
            infoText: recordPage.recordRepeatMode

            anchors.top: timeAndReminderBtn.bottom
            anchors.topMargin: 10
            anchors.left: timeAndReminderBtn.left
            anchors.right: timeAndReminderBtn.right

            onEnabledChanged: {
                if (!enabled) {
                    border.color = "gray"
                    recordPage.recordRepeatMode = "Empty"
                }
                else {
                    border.color = "skyblue"
                }
            }

            onClicked: {
                repeatDialog.x = recordPage.dialogXPos
                repeatDialog.y = recordPage.dialogYPos
                repeatDialog.open()
            }

            RepeatDialog {
                id: repeatDialog

                onAcceptedSet: {
                    recordPage.recordRepeatMode = repeatDialog.selectedRepeatModeStr
                }
            }
        }

        PageButton {
            id: notesBtn

            image: "qrc:/images/RecordPageIcons/notes.png"
            title: "Notes"
            infoText: recordNotesEdit.text !== "" ? "EDIT" : "ADD"

            anchors.top: repeatBtn.bottom
            anchors.topMargin: 10
            anchors.left: repeatBtn.left
            anchors.right: repeatBtn.right

            onClicked: {
               mainView.push(recordNotesPage)
            }

            SimplePage {
                id: recordNotesPage

                RecordTextEdit {
                    id: recordNotesEdit

                    text: recordPage.recordNotes

                    placeHolderText: "Enter notes here..."
                    maximumTextLength: 200

                    anchors.fill: parent
                    anchors.topMargin: 5
                    anchors.margins: 5
                }
            }

        }

        PageButton {
            id: saveBtn
            width: 200
            color: "lightblue"

            Text {
                anchors.centerIn: parent
                text: "Save"
                font.bold: true
                font.pixelSize: 18
                font.family: "Helvetica"
                color: "cadetblue"
            }

            anchors.right: notesBtn.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            DiaryMessageBox {
                id: errorDialog
                titleText: "Input error"
                messageText: "Not all data is filled in!"
            }

            onClicked: {

                if (!isInputCorrect()) {
                    errorDialog.x = errorDialog.width / 2 - recordPage.width / 2 - errorDialog.width / 4
                    errorDialog.y = recordPage.dialogYPos - errorDialog.width / 3
                    errorDialog.open()
                    return
                }

                if (!mainModel.isRecordExists(recordPage.recordID)) {

                    mainModel.addItem(recordPage.recordTitle, recordPage.recordDate, recordPage.recordTime, recordPage.recordReminderTime,
                                      recordPage.recordRepeatMode, recordPage.recordCategory, recordPage.recordNotes, false);
                }
                else {
                    mainModel.updateItem(recordPage.recordTitle, recordPage.recordDate, recordPage.recordTime, recordPage.recordReminderTime,
                                         recordPage.recordRepeatMode, recordPage.recordCategory, recordPage.recordNotes, false, recordPage.recordID);
                }

                mainView.pop();
            }

            function isInputCorrect() {

                var isTitleCorrect = recordPage.recordTitle
                var isDateCorrect  = Qt.formatDate(recordPage.recordDate, "yyyy/MM/dd") !== Qt.formatDate(new Date(2100, 2, 3), "yyyy/MM/dd")
                var isTimeCorrect  = recordPage.recordTime !== "Empty"

                recordTitleEdit.border.color        = !isTitleCorrect ? "red" : "skyblue"
                dateBtn.border.color                = !isDateCorrect  ? "red" : "skyblue"
                timeAndReminderBtn.border.color     = !isTimeCorrect  ? "red" : "skyblue"

                return isTitleCorrect && isDateCorrect && isTimeCorrect
            }
        }
    }
}
