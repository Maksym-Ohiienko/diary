import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Switch {
    id: root

    width:  indicator.width
    height: indicator.height

    signal clicked()

    indicator: RoundButton {

        id: indicator
        width: 70
        height: 30

        Rectangle {
            id: indicatorRect
            width: indicator.height
            height: indicator.height
            radius: indicator.height / 2

            color: "white"
        }

        onClicked: {
            root.checked = !root.checked
            root.clicked()
        }
    }

    states: [
        State {
            name: "checked"
            when: root.checked

            PropertyChanges {
                target: indicatorRect
                x: indicator.width - indicatorRect.width
                border.color: "lightblue"
            }

            PropertyChanges {
                target: indicator
                buttonColor: "blue"
            }
        },
        State {
            name: "unchecked"
            when: !root.checked

            PropertyChanges {
                target: indicatorRect
                x: 0
                border.color: "skyblue"
            }

            PropertyChanges {
                target: indicator
                buttonColor: root.enabled ? "skyblue" : "lightgray"
            }
        }
    ]

    transitions: [
        Transition {
            from: "checked"
            to: "unchecked"

            ParallelAnimation {
                PropertyAnimation { target: indicatorRect; property: "x"; duration: 500; easing.type: Easing.InCubic}
                ColorAnimation { target: indicator; property: "buttonColor"; duration: 500; easing.type: Easing.InCubic }
            }
        },
        Transition {
            from: "unchecked"
            to: "checked"

            ParallelAnimation {
                PropertyAnimation { target: indicatorRect; property: "x"; duration: 500; easing.type: Easing.InCubic}
                ColorAnimation { target: indicator; property: "buttonColor"; duration: 500; easing.type: Easing.InCubic }
            }
        }
    ]
}
