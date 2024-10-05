import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "."

Dialog {
    id: dateDialog
    width: 300
    height: 300
    modal: Qt.WindowModal

    header: Rectangle {
        width: parent.width
        height: 40
        color: "lightblue"
        border.color: "gray"

        Text {
            text: "Select Month and Year"
            font.pixelSize: 18
            font.bold: false
            anchors.centerIn: parent
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        RowLayout {

            spacing: 20

            PathView {
                id: monthComboBox
                width: 130
                height: 150
                model: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
                currentIndex: selectedDate.getMonth()

                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 20

                delegate: Item {
                    width: monthComboBox.width
                    height: 30
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: index === monthComboBox.currentIndex ? "lightblue" : "transparent"
                        border.color: "white"

                        Text {
                            text: modelData
                            font.pixelSize: 22
                            anchors.centerIn: parent
                        }
                    }
                }

                path: Path {
                    startX: 50
                    startY: 0
                    PathLine { x: 50; y: monthComboBox.height }
                }

                pathItemCount: 5
            }

            PathView {
                id: yearComboBox
                width: 130
                height: 150
                model: ListModel {
                    Component.onCompleted: {
                        for (var year = 1901; year <= 2050; year++) {
                            append({ year: year });
                        }
                        yearComboBox.currentIndex = selectedDate.getFullYear() - 1901
                    }
                }

                delegate: Item {
                    width: yearComboBox.width
                    height: 30
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: index === yearComboBox.currentIndex ? "lightblue" : "transparent"
                        border.color: "white"

                        Text {
                            text: model.year
                            font.pixelSize: 22
                            anchors.centerIn: parent
                        }
                    }
                }

                path: Path {
                    startX: 50
                    startY: 0
                    PathLine { x: 50; y: yearComboBox.height }
                }

                pathItemCount: 5
            }
        }
    }
    footer: RowLayout {
        width: parent.width

        RoundButton {
            text: "CANCEL"
            font.pixelSize: 12
            buttonColor: "lightblue"
            textColor: "black"

            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 130
            Layout.margins: 5
            height: 30

            onClicked: dateDialog.visible = false
        }

        RoundButton {
            text: "OK"
            font.pixelSize: 12
            buttonColor: "deepskyblue"
            textColor: "black"

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: 130
            Layout.margins: 5
            height: 30

            onClicked: {
                dateDialog.visible = false
                selectedDate.setMonth(monthComboBox.currentIndex)
                selectedDate.setFullYear(yearComboBox.currentIndex + 1901)
            }
        }
    }

    onVisibleChanged: {

        if (!visible) return

        if (isSelectedDateCorrect()) {
            monthComboBox.currentIndex = selectedDate.getMonth()
            yearComboBox.currentIndex = selectedDate.getFullYear() - 1901
        }
    }
}

