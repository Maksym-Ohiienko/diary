import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.1
import "."

Dialog {
    id: root

    property var    sortModeModel: ["Deadline(ASC)", "Deadline(DESC)", "Notes dimension(ASC)", "Notes dimension(DESC)", "Alphabet(ASC)", "Alphabet(DESC)"]
    property string selectedSortingModeStr: sortModeModel[2]

    width: 400
    height: 500
    modal: Qt.WindowModal

    header: Rectangle {
        width: parent.width
        height: 40
        color: "lightblue"
        border.color: "skyblue"
        border.width: 1

        Text {
            text: "Sort by"
            font.family: "Helvetica"
            font.pixelSize: 28
            color: "white"
            anchors.centerIn: parent
            anchors.margins: 15
        }
    }

    Column {
        spacing: 20

        Repeater {
            id: sortView
            property int selectedIndex: 2
            model: root.sortModeModel

            RadioButton {
                id: radioBtn
                text: modelData
                font.family: "Helvetica"
                font.pixelSize: 24
                checked: index === sortView.selectedIndex

                background: RoundButton {
                    id: background
                    width: radioBtn.width + 30
                    height: radioBtn.height
                    border.width: 2
                    border.color: radioBtn.checked ? "skyblue" : "transparent"
                    buttonColor: radioBtn.checked ? "lightblue" : "transparent"
                }

                indicator: Rectangle {
                    id: indicator
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.color: "blue"
                    border.width: 2

                    Rectangle {
                        id: indicatorCircle
                        opacity: radioBtn.checked ? 1 : 0
                        color: "blue"
                        width: parent.width - 10
                        height: parent.height - 10
                        radius: parent.radius

                        anchors.centerIn: parent
                    }

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }

                contentItem: Text {
                    id: contentItem
                    text: radioBtn.text
                    color: radioBtn.checked ? "blue" : "royalblue"
                    font.family: radioBtn.font.family
                    font.pixelSize: radioBtn.font.pixelSize

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: indicator.right
                    anchors.leftMargin: 5
                }

                states: [
                    State {
                        name: "checked"
                        when: radioBtn.checked

                        PropertyChanges {
                            target: indicatorCircle
                            opacity: 1
                        }
                        PropertyChanges {
                            target: background
                            buttonColor: "lightblue"
                            border.color: "skyblue"
                        }
                    },
                    State {
                        name: "unchecked"
                        when: !radioBtn.checked

                        PropertyChanges {
                            target: indicatorCircle
                            opacity: 0
                        }
                        PropertyChanges {
                            target: background
                            buttonColor: "transparent"
                            border.color: "transparent"
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "unchecked"
                        to: "checked"

                        ParallelAnimation {
                            PropertyAnimation   { target: indicatorCircle; property: "opacity"; duration: 700; easing.type: Easing.InOutQuad }
                            ColorAnimation      { target: background; property: "buttonColor"; duration: 700; easing.type: Easing.InOutQuad }
                            ColorAnimation      { target: background; property: "border.color"; duration: 700; easing.type: Easing.InOutQuad }
                        }
                    },
                    Transition {
                        from: "checked"
                        to: "unchecked"

                        ParallelAnimation {
                            PropertyAnimation   { target: indicatorCircle; property: "opacity"; duration: 700; easing.type: Easing.InOutQuad }
                            ColorAnimation      { target: background; property: "buttonColor"; duration: 700; easing.type: Easing.InOutQuad }
                            ColorAnimation      { target: background; property: "border.color"; duration: 700; easing.type: Easing.InOutQuad }
                        }
                    }
                ]

                onClicked: {
                    sortView.selectedIndex = index
                    root.selectedSortingModeStr = modelData
                }
            }
        }
    }

    footer: Item {
        id: footer
        height: 60
        width: root.width

        RoundButton {
            text: "OK"
            font.pixelSize: 21
            font.family: "Helvetica"
            buttonColor: "skyblue"
            textColor: "white"

            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.bottomMargin: 15
            anchors.verticalCenter: parent.verticalCenter

            width: 100
            height: footer.height - 10

            onClicked: root.close()
        }
    }
}
