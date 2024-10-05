QT       += quick qml quickwidgets core gui sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

SOURCES += \
    categoryManager.cpp \
    diaryModel.cpp \
    diaryProxyModel.cpp \
    diarydb.cpp \
    exportManager.cpp \
    main.cpp \
    notificationManager.cpp

HEADERS += \
    categoryManager.h \
    diaryModel.h \
    diaryProxyModel.h \
    diarydb.h \
    exportManager.h \
    notificationManager.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Main.qml \
    SimplePage.qml \
    RoundButton.qml \
    DiaryCalendar.qml \
    SelectDateDialog.qml \
    AddButton.qml \
    DiaryToolBar.qml \
    RecordPage.qml \
    PageButton.qml \
    CalendarDialog.qml \
    TimeAndReminderDialog.qml \
    RepeatDialog.qml \
    RecordTextEdit.qml \
    RecordListPage.qml \
    RecordListPageView.qml \
    SortModeDialog.qml \
    CalendarPage.qml \
    DiaryToolTip.qml \
    DiaryComboBox.qml \
    PrintPage.qml \
    ProfilePage.qml \
    DiaryMessageBox.qml \
    DiarySwitch.qml

RESOURCES += qml.qrc
