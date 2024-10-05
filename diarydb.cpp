#include "diarydb.h"

DiaryDB :: DiaryDB(QObject* parent)
    : QObject(parent)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbPath());

    if (!m_db.open()) {
        qDebug() << "Error of open DB: " << m_db.lastError();
    }
}

DiaryDB& DiaryDB :: instance() {

    static DiaryDB instance;
    return instance;
}

QString DiaryDB :: dbPath() const {

    QDir dir(QCoreApplication::applicationDirPath());

    dir.cdUp();

    return dir.filePath("database/DiaryDB");
}

QSqlDatabase DiaryDB :: getDb() const {
    return m_db;
}



