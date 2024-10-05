import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.1
import "."

ApplicationWindow {
    id: mainWindow
    title: "Diary"
    minimumWidth: 480
    minimumHeight: 720

    visible: notificationManager ? notificationManager.mainWindowVisible : false

    onClosing: {
        notificationManager.onMainWindowClosing();
    }

    /////////////////////
    // Main View
    StackView {
        id: mainView
        anchors.fill: parent
        anchors.topMargin: toolBar.height
        initialItem: mainPage

        onCurrentItemChanged: {
            toolBar.isSearchLineVisible = false
            toolBar.searchLineText = ""
        }
    }

    /////////////////////
    // Main page
    SimplePage {
        id: mainPage
        backgroundColor: "darkblue"
        AddButton {
            id: mainAddButton
            anchors.centerIn: parent

            onClicked: {
                addNewNote.clearInputData()
                mainView.push(addNewNote)
            }

            RecordPage { id: addNewNote }
        }

        // Footer view
        footer: RowLayout {
            id: footerRow
            spacing: 50

            property Item clickedButton: taskBtn

            SequentialAnimation {
                id: clickAnimation
                running: false

                ParallelAnimation {
                    PropertyAnimation {
                        target: footerRow.clickedButton
                        property: "scale"
                        to: 0.8
                        duration: 300
                        easing.type: Easing.OutQuad
                    }

                    PropertyAnimation {
                        target: footerRow.clickedButton
                        property: "buttonColor"
                        to: "royalblue"
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                ParallelAnimation {
                    PropertyAnimation {
                        target: footerRow.clickedButton
                        property: "scale"
                        to: 1.0
                        duration: 300
                        easing.type: Easing.InQuad
                    }
                    PropertyAnimation {
                        target: footerRow.clickedButton
                        property: "buttonColor"
                        to: "blue"
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                onFinished: {
                    if (footerRow.clickedButton === taskBtn) {
                        mainView.push(recordListPage);
                    } else if (footerRow.clickedButton === calendarBtn) {
                        mainView.push(calendarPage);
                    } else if (footerRow.clickedButton === profileBtn) {
                        mainView.push(profilePage);
                    }
                }
            }

            RoundButton {
                id: taskBtn
                size: 80
                backgroundOpacity: 0.2
                Layout.alignment: Qt.AlignLeft
                Layout.margins: 20
                image: "qrc:/images/MainPageIcons/todoList.png"

                onClicked: {
                    footerRow.clickedButton = taskBtn;
                    clickAnimation.start();
                }
            }

            RoundButton {
                id: calendarBtn
                size: 80
                backgroundOpacity: 0.2
                Layout.alignment: Qt.AlignCenter
                Layout.margins: 20
                image: "qrc:/images/MainPageIcons/calendar.png"

                onClicked: {
                    footerRow.clickedButton = calendarBtn;
                    clickAnimation.start();
                }
            }

            RoundButton {
                id: profileBtn
                size: 80
                backgroundOpacity: 0.2
                Layout.alignment: Qt.AlignRight
                Layout.margins: 20
                image: "qrc:/images/MainPageIcons/profile.png"

                onClicked: {
                    footerRow.clickedButton = profileBtn;
                    clickAnimation.start();
                }
            }
        }
    }

    /////////////////////
    // Tool bar
    DiaryToolBar {
        id: toolBar
    }

    /////////////////////
    // RecordList page
    RecordListPage {
        id: recordListPage
    }

    /////////////////////
    // Calendar page
    CalendarPage {
        id: calendarPage
    }

    /////////////////////
    // Profile page
    ProfilePage {
        id: profilePage
    }
}
