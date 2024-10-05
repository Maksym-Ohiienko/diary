import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Fusion
import QtQuick.Layouts 1.1
import "."

Rectangle {
    id: toolBar
    width: parent.width
    height: 60
    color: Qt.darker(mainView.currentItem.backgroundColor, 1.1)

    property alias isSearchLineVisible: searchLine.visible
    property alias searchLineText: searchLine.text
    property alias reminderOn: reminderTool.checked

    Item {
        id: toolRow
        anchors.fill: parent

        property real dialogXPos: (mainView.width - sortDialog.width) / 2
        property real dialogYPos: sortDialog.height / 6

        ToolButton {
            DiaryMessageBox {
                id: confirmDialog
                titleText: "Confirm the action"
                messageText: "Are you sure you want to exit?\n(Unsaved data will be lost)"
                messageTextFont.pixelSize: 18
                cancelEnabled: true

                onAccepted: mainView.pop()
            }

            visible: mainView.depth > 1
            hoverEnabled: false
            onClicked: {
                if (mainView.currentItem.isRecordPage) {
                    confirmDialog.x = mainView.width / 2 - confirmDialog.width / 2 - 5
                    confirmDialog.y = mainView.height / 2 - confirmDialog.height / 2
                    confirmDialog.open()
                } else {
                    mainView.pop()
                }
            }

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5

            icon.source: "qrc:/images/MainPageIcons/back.png"
            icon.width: 24
            icon.height: 24

            background: Rectangle {
                color: "transparent"
            }
        }

        ToolButton {
            id: reminderTool
            visible: mainView.depth === 1

            checked: true
            icon.source: "qrc:/images/RecordPageIcons/reminder.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            hoverEnabled: false

            icon.width: 32
            icon.height: 32

            onClicked: {
                checked = !checked

                icon.source = checked ? "qrc:/images/RecordPageIcons/reminder.png" : "qrc:/images/MainPageIcons/reminderOff.png"

                if (!checked) {
                    mainModel.offReminders()
                }
            }

            background: Rectangle {
                color: "transparent"
            }
        }

        ToolButton {
            id: feedbackBtn
            visible: mainView.depth === 1

            anchors.left: reminderTool.right
            anchors.verticalCenter: reminderTool.verticalCenter
            anchors.margins: 5
            hoverEnabled: false

            icon.source: "qrc:/images/MainPageIcons/feedback.png"
            icon.width: 32
            icon.height: 32

            onClicked: {
                Qt.openUrlExternally("https://mail.google.com/mail/?view=cm&fs=1&to=4yrbantyt777@gmail.com")
            }

            background: Rectangle {
                color: "transparent"
            }
        }

        RecordTextEdit {
            id: searchLine
            width: toolBar.width / 2
            height: toolBar.height - 5
            placeHolderFont.pixelSize: 16
            textFont.pixelSize: 16
            border.color: "skyblue"
            border.width: 1
            textColor: "cadetblue"
            backgroundColor: "white"
            selectionColor: "lightblue"
            maximumTextLength: 20

            anchors.right: searchTool.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 3

            visible: false
            placeHolderText: "Enter title for searching..."

            onTextLengthChanged: {
                if (!searchLine.text) {
                    mainModel.proxyModel().clearFilter()
                } else {
                    mainModel.proxyModel().setFilterTitle(searchLine.text)
                }
            }

            onVisibleChanged: {
                if (!visible) {
                    mainModel.proxyModel().clearFilter()
                }
                else {
                    mainModel.proxyModel().setFilterTitle(searchLine.text)
                }
            }

            onEnterReleased: {
                searchLine.visible = false
                toolBar.forceActiveFocus()
            }
        }

        ToolButton {
            id: searchTool
            visible: mainView.depth === 1

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            hoverEnabled: false

            icon.source: "qrc:/images/MainPageIcons/search.png"
            icon.width: 32
            icon.height: 32

            onClicked: {
                mainView.push(recordListPage)
                searchLine.visible = !searchLine.visible
                searchLine.forceActiveFocus()
            }

            background: Rectangle {
                color: "transparent"
            }
        }

        ToolButton {
            id: tripleDotBtn
            visible: mainView.currentItem === recordListPage

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            hoverEnabled: false

            icon.source: "qrc:/images/MainPageIcons/dotsMenu.png"
            icon.width: 24
            icon.height: 24

            background: Rectangle {
                color: "transparent"
            }

            onClicked: {
                menu.y = toolBar.height
                menu.open()
            }

            DiaryMessageBox {
                id: confirmClearingDialog
                titleText: "Confirm the action"
                messageText: "Are you sure?"
                messageTextFont.pixelSize: 24
                cancelEnabled: true

                onAccepted: mainModel.clearCompletedRecords()
            }

            Menu {
                id: menu

                property int itemHeight: 30

                width: 200
                height: itemHeight * count + 5

                background: Rectangle {
                    width: menu.width
                    height: menu.height
                    color: "skyblue"
                    radius: 10
                }

                Repeater {
                    model: ["Search", "Sorting", "Print", "Clear completed records"]

                    MenuItem {
                        id: menuItem
                        width: parent.width
                        height: parent.itemHeight

                        hoverEnabled: false

                        RoundButton {
                            anchors.fill: parent
                            buttonColor: containsMouse ? "blue" : "transparent"
                            textColor: containsMouse ? "white" : "darkblue"
                            text: modelData
                            font.pixelSize: 14

                            onClicked: {
                                menu.close()

                                if (modelData === "Clear completed records") {
                                    confirmClearingDialog.x = -mainView.width / 2 - confirmClearingDialog.width / 3 - 10
                                    confirmClearingDialog.y = confirmClearingDialog.width / 2
                                    confirmClearingDialog.open()
                                }
                                else if (modelData === "Search") {
                                    searchLine.visible = !searchLine.visible
                                }
                                else if (modelData === "Sorting") {

                                    sortDialog.x = toolRow.dialogXPos
                                    sortDialog.y = toolRow.dialogYPos
                                    sortDialog.open()

                                }
                                else if (modelData === "Print") {
                                    mainView.push(printPage)
                                }
                            }
                        }

                    }
                }
            }
        }
    }

    SortModeDialog {
        id: sortDialog

        onClosed: {
            mainModel.sortRecords(sortDialog.selectedSortingModeStr)
        }
    }

    PrintPage {
        id: printPage
    }
}
