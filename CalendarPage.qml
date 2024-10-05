import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.1
import "."

SimplePage {
    id: root
    backgroundColor: "lightblue"

    Item {
        anchors.fill: parent

        DiaryCalendar {
            id: calendar
            width: parent.width
            height: parent.height

            theme: ""

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: calendarList.top
            anchors.margins: 10

            onSelectedDateChanged: {
                if (root.visible) {
                    calendarList.model.setFilterDate(selectedDate)
                }
            }
        }

        ListView {
            property int listElHeight: 60
            property int listElWidth: parent.width

            id: calendarList
            width: listElWidth
            height: parent.height

            clip: true

            anchors.top: parent.verticalCenter
            anchors.topMargin: 100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter

            model: mainModel ? mainModel.proxyModel() : []

            delegate: Item {
                id: listDelegate
                width: calendarList.listElWidth
                height: calendarList.listElHeight

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "skyblue"
                    radius: 10
                    anchors.fill: parent
                    anchors.margins: calendarList.listElHeight / 6

                    Text {
                        text: model.title
                        font.pixelSize: 16
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            calendarList.currentIndex = index

                            recordViewPage.recordID                    = parseInt(recordViewPage.getCurrentViewData(calendarList, "ID", "0"))
                            recordViewPage.recordTitle                 = recordViewPage.getCurrentViewData(calendarList, "title", "Empty")
                            recordViewPage.recordDate                  = recordViewPage.getCurrentViewData(calendarList, "date", new Date())
                            recordViewPage.recordTime                  = recordViewPage.getCurrentViewData(calendarList, "time", "Empty")
                            recordViewPage.recordReminderTime          = recordViewPage.getCurrentViewData(calendarList, "reminder", "Empty")
                            recordViewPage.recordRepeatMode            = recordViewPage.getCurrentViewData(calendarList, "repeatMode", "Empty")
                            recordViewPage.recordCategory              = recordViewPage.getCurrentViewData(calendarList, "category", "Empty")
                            recordViewPage.recordNotes                 = recordViewPage.getCurrentViewData(calendarList, "notes", "")

                            mainView.push(recordViewPage)
                        }
                    }

                    Image {
                        id: itemHasReminderMark

                        visible: !model.completed
                        source: model.reminder ? "qrc:/images/RecordPageIcons/reminder.png" : "qrc:/images/MainPageIcons/reminderOff.png"
                        width: 24
                        height: 24

                        anchors.right: itemRepeatedMark.left
                        anchors.verticalCenter: itemRepeatedMark.verticalCenter
                        anchors.rightMargin: 10
                    }

                    Image {
                        id: itemRepeatedMark

                        visible: model.repeatMode !== "Empty"
                        source: "qrc:/images/RecordPageIcons/repeat.png"
                        width: 24
                        height: 24

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 20
                    }
                }
            }

            RecordPage {
                id: recordViewPage

                recordID:               getCurrentViewData(calendarList, "ID", 0)
                recordTitle:            getCurrentViewData(calendarList, "title", "Empty")
                recordDate:             getCurrentViewData(calendarList, "date", new Date())
                recordTime:             getCurrentViewData(calendarList, "time", "Empty")
                recordReminderTime:     getCurrentViewData(calendarList, "reminder", "Empty")
                recordRepeatMode:       getCurrentViewData(calendarList, "repeatMode", "Empty")
                recordCategory:         getCurrentViewData(calendarList, "category", "Empty")
                recordNotes:            getCurrentViewData(calendarList, "notes", "")
            }
        }

        AddButton {
            id: calendarAddButton
            size: 60
            buttonColor: "darkblue"

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: size
            anchors.rightMargin: size

            onClicked: {
                recordByDate.clearInputData()
                recordByDate.recordDate = calendar.selectedDate
                mainView.push(recordByDate)
            }

            RecordPage {
                id: recordByDate
                recordDate: calendar.selectedDate
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            calendarList.model.setFilterDate(calendar.selectedDate)
        } else {
            calendarList.model.clearFilter()
        }
    }
}
