import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "."

Item {
    id: calendar
    property date   selectedDate: new Date()
    property alias  theme: theme.source
    property string selectionColor: "darkblue"
    property real   dialogXPos: (mainView.width - dateDialog.width) / 2
    property real   dialogYPos: (mainView.height - dateDialog.height) / 2

    // Theme
    Image {
        id: theme
        source: ""
        anchors.fill: parent
    }

    Item {
        anchors.fill: parent

        Text {
            id: calendarTxt
            text: Qt.formatDate(isSelectedDateCorrect() ? selectedDate : new Date(), "MMMM yyyy") + " ▼"
            font.pointSize: 16
            font.bold: true
            color: "black"

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    dateDialog.x = dialogXPos
                    dateDialog.y = dialogYPos
                    dateDialog.open()
                }
            }

            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RoundButton {
            buttonColor: "transparent"
            image: "qrc:/images/CalendarPageIcons/calendarBackDate.png"
            imageWidth: 24
            imageHeight: 24

            width: imageWidth
            height: imageHeight

            visible: selectedDate.toDateString() !== new Date().toDateString() && isSelectedDateCorrect()

            anchors.left: calendarTxt.right
            anchors.leftMargin: 20
            anchors.top: calendarTxt.top
            anchors.topMargin: 5

            onClicked: selectedDate = new Date()
        }

        DayOfWeekRow {
            id: dayWeek
            locale: grid.locale

            width: grid.width

            anchors.top: calendarTxt.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MonthGrid {
            id: grid
            locale: Qt.locale("en_US")

            month: isSelectedDateCorrect() ? selectedDate.getMonth()    : new Date().getMonth()
            year:  isSelectedDateCorrect() ? selectedDate.getFullYear() : new Date().getFullYear()

            anchors.top: dayWeek.bottom
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            delegate: RoundButton {
                id: dayRect
                size: 50
                property bool isSelected: model.date.toDateString() === selectedDate.toDateString()
                property bool isCurrentMonth: model.date.getMonth() === grid.month

                buttonColor: (isSelected ? selectionColor : "transparent")

                Text {
                    id: buttonText
                    text: model.date.getDate()
                    font.pointSize: 12
                    anchors.centerIn: parent
                    color: isCurrentMonth
                        ? (isSelected ? "white" : "black")
                        : "gray"
                }

                Rectangle {
                    id: dateHasRecord

                    visible: mainModel && mainView.currentItem === calendarPage && model.date.toDateString() !== selectedDate.toDateString()
                             ? mainModel.haveRecordsAtDate(model.date) : false

                    radius: 5
                    width: 10
                    height: width
                    color: selectionColor

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    id: dayMouseArea
                    anchors.fill: parent
                    onClicked: {
                        selectedDate = model.date
                    }
                }

                states: [
                    State {
                        name: "selected"
                        when: isSelected

                        PropertyChanges {
                            target: buttonText
                            color: "white"
                        }

                        PropertyChanges {
                            target: dayRect
                            buttonColor: selectionColor
                        }
                    },
                    State {
                        name: "unselected"
                        when: !isSelected

                        PropertyChanges {
                            target: buttonText
                            color: isCurrentMonth ? "black" : "gray"
                        }

                        PropertyChanges {
                            target: dayRect
                            buttonColor: "transparent"
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "unselected"
                        to: "selected"

                        ParallelAnimation {
                            ColorAnimation { target: buttonText; property: "color"; duration: 500; easing.type: Easing.InCubic}
                            ColorAnimation { target: dayRect; property: "buttonColor"; duration: 500; easing.type: Easing.InCubic }
                        }
                    },
                    Transition {
                        from: "selected"
                        to: "unselected"

                        ParallelAnimation {
                            ColorAnimation { target: buttonText; property: "color"; duration: 500; easing.type: Easing.InCubic }
                            ColorAnimation { target: dayRect; property: "buttonColor"; duration: 500; easing.type: Easing.InCubic }
                        }
                    }
                ]
            }

        }
    }
    SelectDateDialog {
        id: dateDialog
        visible: false
    }

    function isSelectedDateCorrect() {
        return selectedDate.toDateString() !== new Date(2100, 2, 3).toDateString()
    }
}
