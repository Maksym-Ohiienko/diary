import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.1
import "."

SimplePage {
    id: root
    backgroundColor: "lightblue"

    Item {
        id: pageContent
        anchors.fill: parent

        PathView {
            id: categoryPath

            model: categoryManager ? categoryManager.categoryList() : []
            currentIndex: 0

            width: root.width
            height: 50
            anchors.top: parent.top
            anchors.left: parent.left
            clip: true

            onCurrentIndexChanged: {
                if (root.visible) {
                    activeRecs.model.setFilterCategory(model[currentIndex].category)
                }
            }

            delegate: RoundButton {
                id: pathBtn

                width: pathTextMetrics.width + 40
                height: pathTextMetrics.height + 20

                text: index ? categoryPath.model[index].category : "All"
                buttonColor: parent.currentIndex === index ? "blue" : "skyblue"
                textColor:   parent.currentIndex === index ? "skyblue" : "white"
                font.pixelSize: 16
                font.bold: parent.currentIndex === index

                TextMetrics {
                    id: pathTextMetrics
                    text: pathBtn.text
                    font.pixelSize: pathBtn.font.pixelSize
                }

                onClicked: {
                    parent.currentIndex = index
                }
            }

            path: Path {
                id: path
                startX: 50
                startY: 25

                PathLine {
                    x: categoryPath.width + path.startX; y: path.startY
                }
            }

            pathItemCount: width / 100
        }

        Text {
            id: activeTasksTxt
            text: "Active tasks:"
            color: "blue"
            font.pixelSize: 21
            font.family: "Helvetica"
            font.bold: true

            anchors.top: categoryPath.bottom
            anchors.topMargin: 10
            anchors.left: categoryPath.left
            anchors.leftMargin: 10
        }

        RecordListPageView {
            id: activeRecs

            model: mainModel ? mainModel.proxyModel() : []

            anchors.top: activeTasksTxt.bottom
            anchors.left: parent.left
            anchors.topMargin: 10
        }

        Text {
            id: completedTasksTxt
            text: "Completed tasks:"
            color: "blue"
            font.pixelSize: 21
            font.family: "Helvetica"
            font.bold: true

            anchors.left: activeRecs.left
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.top: activeRecs.bottom
        }

        RecordListPageView {
            id: completedRecs

            model: mainModel ? mainModel.proxyModel() : []

            isListEnabled: false
            isOnlyCompletedVisible: true

            anchors.top: completedTasksTxt.bottom
            anchors.left: parent.left
            anchors.topMargin: 10
        }

        AddButton {
            id: calendarAddButton
            size: 70
            buttonColor: "blue"

            anchors.right: parent.right
            anchors.rightMargin: size
            anchors.bottom: parent.bottom
            anchors.bottomMargin: size

            onClicked: {
                newRecord.clearInputData()
                mainView.push(newRecord)
            }

            RecordPage {
                id: newRecord
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            activeRecs.model.setFilterCategory(categoryPath.model[categoryPath.currentIndex].category)
        } else {
            activeRecs.model.clearFilter()
        }
    }
}
