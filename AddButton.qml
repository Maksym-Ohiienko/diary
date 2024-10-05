import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "."

Item {
    id: root
    property int size: 120
    property color buttonColor: "blue"

    signal clicked()

    // Back button for animation only
    RoundButton {
        id: animBtn
        size: root.size
        opacity: 0.3
        z: 0
        buttonColor: root.buttonColor
        anchors.centerIn: parent

        ParallelAnimation {
            id: buttonAnim
            loops: Animation.Infinite
            PropertyAnimation {
                target: animBtn
                property: "size"
                from: animBtn.size
                to: animBtn.size * 2
                duration: 2000
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: animBtn
                property: "opacity"
                from: 0.3
                to: 0
                duration: 2000
                easing.type: Easing.InOutQuad
            }
        }

        Component.onCompleted: {
            buttonAnim.start()
        }
    }

    // Add button
    RoundButton {
        id: addBtn
        text: "+"
        font.pixelSize: size / 2
        buttonColor: root.buttonColor
        size: root.size
        anchors.centerIn: parent
        z: 1

        onClicked: {
            root.clicked()
        }
    }
}
