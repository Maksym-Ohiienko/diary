import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.1
import "."

ToolTip {
    id: root

    property alias title: contentItem.text

    background: Rectangle {
        id: background
        color: "skyblue"
        radius: 10
    }

    contentItem: Text {
        id: contentItem
        color: "blue"
        font.pixelSize: 14
    }
}
