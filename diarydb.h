#ifndef DIARYDB_H
#define DIARYDB_H

#include <QDir>
#include <QSqlDatabase>
#include <QSqlError>
#include <QObject>
#include <QCoreApplication>
#include <QSqlQuery>

class DiaryDB : public QObject
{
    Q_OBJECT

public:

    static DiaryDB& instance();

    DiaryDB(const DiaryDB&) = delete;
    DiaryDB& operator=(const DiaryDB&) = delete;

    QString dbPath() const;
    QSqlDatabase getDb() const;

private:
    explicit DiaryDB(QObject* parent = nullptr);
    ~DiaryDB() = default;

    QSqlDatabase m_db;
};

#endif // DIARYDB_H
