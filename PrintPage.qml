import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Fusion
import QtQuick.Layouts 1.1
import QtQuick.Dialogs
import "."

SimplePage {
    id: root
    backgroundColor: "lightblue"

    Item {
        id: printPageContent
        anchors.fill: parent

        PageButton {
            id: dateFromBtn
            width: parent.width / 2 - 10
            image: "qrc:/images/PrintPageIcons/dateFrom.png"
            imageWidth: 28
            imageHeight: 28
            infoText: Qt.formatDate(new Date(), "yyyy/MM/dd")
            infoTextColor: "royalblue"
            font.bold: false
            font.pixelSize: 18

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 35
            anchors.leftMargin: 5

            onClicked: {
                calendarDlgFrom.x = toolRow.dialogXPos
                calendarDlgFrom.y = toolRow.dialogYPos
                calendarDlgFrom.open()
            }

            CalendarDialog {
                id: calendarDlgFrom

                onAcceptedSelect: {

                    var dateFrom = new Date(calendarDlgFrom.selectedDateStr)
                    var dateTo = new Date(dateToBtn.infoText)

                    dateFromBtn.infoText = dateTo < dateFrom ? dateToBtn.infoText : calendarDlgFrom.selectedDateStr
                }
            }

            DiaryToolTip {
                id: dateFromToolTip

                visible: dateFromBtn.containsMouse
                title: "Start date"
            }
        }

        PageButton {
            id: dateToBtn
            width: parent.width / 2 - 10
            image: "qrc:/images/PrintPageIcons/dateCheck.png"
            imageWidth: 28
            imageHeight: 28
            infoText: Qt.formatDate(new Date(), "yyyy/MM/dd")
            infoTextColor: "royalblue"
            font.bold: false
            font.pixelSize: 18

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 35
            anchors.rightMargin: 5

            onClicked: {
                calendarDlgTo.x = toolRow.dialogXPos - width - 10
                calendarDlgTo.y = toolRow.dialogYPos
                calendarDlgTo.open()
            }

            CalendarDialog {
                id: calendarDlgTo

                onAcceptedSelect: {

                    var dateFrom = new Date(dateFromBtn.infoText)
                    var dateTo = new Date(calendarDlgTo.selectedDateStr)

                    dateToBtn.infoText = dateTo < dateFrom ? dateFromBtn.infoText : calendarDlgTo.selectedDateStr
                }
            }

            DiaryToolTip {
                id: dateToToolTip

                visible: dateToBtn.containsMouse
                title: "End date"
            }
        }

        Column {
            id: checkBoxColumn
            spacing: 10

            anchors.top: dateFromBtn.bottom
            anchors.left: dateFromBtn.left
            anchors.topMargin: 20

            Repeater {
                id: repeaterView
                model: ["Completed records", "Only unique records", "Include notes", "File for each date"]

                CheckBox {
                    id: checkBox
                    checked: false

                    background: Rectangle {
                        id: background
                        width: checkBox.width + 30
                        height: checkBox.height
                        color: "transparent"
                    }

                    indicator: Rectangle {
                        id: indicator
                        width: height
                        height: contentItem.height + 10
                        radius: 5
                        color: "transparent"
                        border.width: 2
                        border.color: checkBox.checked ? "skyblue" : "white"

                        Rectangle {
                            width: parent.width / 2 + 5
                            height: parent.height / 2 + 5
                            radius: parent.radius
                            color: "skyblue"
                            visible: checkBox.checked

                            anchors.centerIn: parent
                        }
                    }

                    contentItem: Text {
                        id: contentItem
                        text: modelData
                        font.pixelSize: 18
                        color: "royalblue"

                        anchors.verticalCenter: checkBox.verticalCenter
                        anchors.left: indicator.right
                        anchors.leftMargin: 5
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: background

                        onClicked: {
                            parent.checked = !parent.checked
                        }
                    }
                }
            }
        }

        DiaryComboBox {
            id: fileFormatCb
            backgroundColor: "white"
            itemColor: "royalblue"
            indicatorColor: "royalblue"

            model: ["PDF document(.pdf)", "Text document(.txt)", "XML document(.xml)", "JSON document(.json)"]

            anchors.top: checkBoxColumn.bottom
            anchors.topMargin: 40
            anchors.left: checkBoxColumn.left
        }


        RoundButton {

            id: exportBtn

            width: dateToBtn.width / 1.5
            height: dateToBtn.height + 5

            text: "Export"
            font.pixelSize: 18
            buttonColor: "skyblue"
            textColor: "white"

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            Image {
                id: btnImage
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/PrintPageIcons/export.png"
                width: 24
                height: 24
            }

            onClicked: {

                if (!isInputCorrect()) {
                    return
                }
                selectFolderDlg.open()
            }

            FolderDialog  {
                id: selectFolderDlg
                title: "Select folder to save"

                onAccepted: {

                    var selectedPath = selectFolderDlg.selectedFolder.toString()
                    selectedPath = selectedPath.slice(8);

                    var selectedFormat = fileFormatCb.model[fileFormatCb.currentIndex]

                    if (selectedFormat === "PDF document(.pdf)") {
                        exportManager.exportPdf(selectedPath, dateFromBtn.infoText, dateToBtn.infoText, repeaterView.itemAt(0).checked, repeaterView.itemAt(1).checked,
                                         repeaterView.itemAt(2).checked, repeaterView.itemAt(3).checked)
                    } else if (selectedFormat === "Text document(.txt)") {
                        exportManager.exportTxt(selectedPath, dateFromBtn.infoText, dateToBtn.infoText, repeaterView.itemAt(0).checked, repeaterView.itemAt(1).checked,
                                         repeaterView.itemAt(2).checked, repeaterView.itemAt(3).checked)
                    } else if (selectedFormat === "XML document(.xml)") {
                        exportManager.exportXml(selectedPath, dateFromBtn.infoText, dateToBtn.infoText, repeaterView.itemAt(0).checked, repeaterView.itemAt(1).checked,
                                         repeaterView.itemAt(2).checked, repeaterView.itemAt(3).checked)
                    } else if (selectedFormat === "JSON document(.json)") {
                        exportManager.exportJson(selectedPath, dateFromBtn.infoText, dateToBtn.infoText, repeaterView.itemAt(0).checked, repeaterView.itemAt(1).checked,
                                         repeaterView.itemAt(2).checked, repeaterView.itemAt(3).checked)
                    }
                }
            }

            function isInputCorrect() {

                var isDateFromCorrect = dateFromBtn.infoText !== "Empty"
                var isDateToCorrect = dateToBtn.infoText !== "Empty"

                dateFromBtn.border.color = !isDateFromCorrect ? "red" : "skyblue"
                dateToBtn.border.color   = !isDateToCorrect   ? "red" : "skyblue"

                return isDateFromCorrect && isDateToCorrect
            }
        }
    }
}
