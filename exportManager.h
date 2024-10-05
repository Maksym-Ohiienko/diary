#ifndef EXPORTMANAGER_H
#define EXPORTMANAGER_H

#include <QObject>
#include <QXmlStreamWriter>
#include <QPdfWriter>
#include <QPainter>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "diaryModel.h"

class DiaryExport : public QObject {

    Q_OBJECT

public:
    explicit DiaryExport(QObject* parent, DiaryModel* model);

    QList<QVariantList>                 getExportList(const QDate& from, const QDate& to);
    QMap<QDate, QList<QVariantList>>    groupListByDate(QList<QVariantList> list);
    void fileForDateExport(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, const QString& format);

    void exportJsonByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);
    Q_INVOKABLE void exportJson(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);

    void exportTxtByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);
    Q_INVOKABLE void exportTxt(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);

    void exportXmlByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);
    Q_INVOKABLE void exportXml(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);

    void exportPdfByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);
    Q_INVOKABLE void exportPdf(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate);

private:
    DiaryModel* m_model;
};

#endif // EXPORTMANAGER_H
