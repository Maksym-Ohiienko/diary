import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.1
import "."

SimplePage {
    id: root
    backgroundColor: "lightblue"

    Item {
        id: profilePageContent
        anchors.fill: parent

        Rectangle {
            id: profileEnter
            color: 'transparent'
            width: parent.width - anchors.leftMargin * 2
            height: 100

            Image {
                id: image
                source: "qrc:/images/ProfilePageIcons/profile.png"
                width:  64
                height: 64
                smooth: true

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: nickname
                text: "Nickname"
                font.pixelSize: 32
                color: "black"

                anchors.left: image.right
                anchors.leftMargin: 30
                anchors.top: image.top
            }

            Text {
                text: "Click here to enter"
                font.pixelSize: 18
                color: "gray"

                anchors.left: nickname.left
                anchors.top: nickname.bottom
                anchors.topMargin: 3
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
            }

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text {
            id: taskOverview
            text: "Task overview:"
            font.pixelSize: 21
            color: "gray"
            font.bold: true

            anchors.left: profileEnter.left
            anchors.top: profileEnter.bottom
            anchors.topMargin: 10
        }

        Component {
            id: modelCountRect

            Rectangle {
                id: root
                radius: 5
                width: parent.width / 2
                height: 60

                property alias countInfo: tasksCount.text
                property alias text: text.text

                Text {
                    id: tasksCount
                    font.bold: true
                    font.pixelSize: 18

                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: text
                    font.bold: true
                    font.pixelSize: 12
                    color: "gray"

                    anchors.top: tasksCount.bottom
                    anchors.topMargin: 3
                    anchors.horizontalCenter: tasksCount.horizontalCenter
                }
            }
        }

        Loader {
            id: completedRecords
            sourceComponent: modelCountRect

            Binding {
                target: completedRecords.item
                property: "countInfo"
                value: mainModel ? mainModel.completedCount : 0
            }

            onLoaded: {
                item.color = Qt.darker(root.backgroundColor, 1.05)
                item.text = "Completed tasks"
            }

            anchors.left: profileEnter.left
            anchors.right: profileEnter.horizontalCenter
            anchors.rightMargin: 5
            anchors.top: taskOverview.bottom
            anchors.topMargin: 5
        }

        Loader {
            id: activeRecords
            sourceComponent: modelCountRect

            Binding {
                target: activeRecords.item
                property: "countInfo"
                value: mainModel ? mainModel.activeCount : 0
            }

            onLoaded: {
                item.color = Qt.darker(root.backgroundColor, 1.05)
                item.text = "Active tasks"
            }

            anchors.left: profileEnter.horizontalCenter
            anchors.leftMargin: 5
            anchors.right: profileEnter.right
            anchors.verticalCenter: completedRecords.verticalCenter
        }

        ListModel {
            id: categoryDiagramModel

            Component.onCompleted: {
                categoryDiagramModel.fillModel()
            }

            function fillModel() {
                var uniqueCategories = mainModel.getByCategoryUniqueList();

                categoryDiagramModel.clear();

                for (var i = 0; i < uniqueCategories.length; i++) {
                    categoryDiagramModel.append({
                        category: uniqueCategories[i].category,
                        color: uniqueCategories[i].color,
                        count: uniqueCategories[i].count
                    });
                }
            }

            function countTotal() {
                var result = 0
                for (var i = 0; i < categoryDiagramModel.count; ++i) {
                    result += categoryDiagramModel.get(i).count
                }
                return result
            }
        }

        Rectangle {
            id: categoryStats
            width: profileEnter.width
            height: root.height
            color: completedRecords.item.color
            radius: 10

            anchors.left: completedRecords.left
            anchors.top: completedRecords.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.topMargin: 20

            Text {
                id: taskClassification
                text: "Classification of active tasks:"
                font.pixelSize: 16
                color: "gray"
                font.bold: true

                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
            }

            Canvas {
                id: pieChart
                width: parent.width / 2
                height: parent.height / 1.5

                anchors.top: taskClassification.bottom
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                onPaint: {
                    var ctx = pieChart.getContext("2d");
                    var centerX = pieChart.width / 2;
                    var centerY = pieChart.height / 2;
                    var radius = Math.min(centerX, centerY) - 10;

                    var total = categoryDiagramModel.countTotal();
                    var startAngle = 0;

                    ctx.clearRect(0, 0, pieChart.width, pieChart.height);

                    for (var index = 0; index < categoryDiagramModel.count; ++index) {

                        var currCount = categoryDiagramModel.get(index).count
                        var sliceAngle = (currCount / total) * 2 * Math.PI;

                        ctx.beginPath();
                        ctx.moveTo(centerX, centerY);
                        ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
                        ctx.closePath();

                        ctx.fillStyle = categoryDiagramModel.get(index).color;
                        ctx.fill();

                        startAngle += sliceAngle;
                    }
                }
            }


            Column {
                anchors.top: pieChart.top
                anchors.topMargin: 25
                anchors.left: pieChart.right
                anchors.leftMargin: 25

                spacing: 15

                Repeater {
                    model: categoryDiagramModel.count

                    delegate: Item {

                        width: colorRect.width + categoryText.implicitWidth + 10
                        height: categoryDiagramModel.get(index).count > 0 ? colorRect.height : 0
                        visible: categoryDiagramModel.get(index).count > 0

                        Rectangle {
                            id: colorRect
                            width: 35
                            height: 35
                            radius: 5
                            color: categoryDiagramModel.get(index).color

                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 5
                        }

                        Text {
                            id: categoryText
                            text: categoryDiagramModel.get(index).category
                            font.pixelSize: 14

                            anchors.left: colorRect.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: colorRect.verticalCenter
                        }

                        Text {
                            id: countText
                            text: categoryDiagramModel.get(index).count
                            font.pixelSize: 16
                            font.bold: true
                            color: "blue"

                            anchors.left: categoryText.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: categoryText.verticalCenter
                        }
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) { // Updating diagram

            categoryDiagramModel.fillModel();
            pieChart.requestPaint();
        }
    }
}
