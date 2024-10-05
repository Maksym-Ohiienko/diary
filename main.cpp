#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "diarydb.h"
#include "diaryModel.h"
#include "exportManager.h"
#include "notificationManager.h"

int main(int argc, char** argv) {

    QApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(false);
    app.setWindowIcon(QIcon(":/images/MainWindowIcon/diary.ico"));

    QQmlApplicationEngine engine;

    DiaryModel          mainModel(nullptr, DiaryDB::instance().getDb());
    DiaryExport         mainExportManager(nullptr, &mainModel);
    NotificationManager notificationManager;

    engine.rootContext()->setContextProperty("mainModel",               &mainModel);
    engine.rootContext()->setContextProperty("categoryManager",         mainModel.jsonManager());
    engine.rootContext()->setContextProperty("exportManager",           &mainExportManager);
    engine.rootContext()->setContextProperty("notificationManager",     &notificationManager);

    engine.load(QUrl("qrc:/qmlSources/Main.qml"));

    return app.exec();
}



