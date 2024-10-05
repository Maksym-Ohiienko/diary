import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Page {
        
    property alias backgroundColor: backgroundRect.color
    visible: false

    background: Rectangle {
        id: backgroundRect
    }
}
