#include "exportManager.h"

DiaryExport :: DiaryExport(QObject* parent, DiaryModel* model) : QObject(parent)
{
    m_model = model;
}

QList<QVariantList> DiaryExport :: getExportList(const QDate& from, const QDate& to) {

    QList<QVariantList> records;

    QSqlQuery query(m_model->database());

    query.prepare("SELECT * FROM Record WHERE date BETWEEN :startDate AND :endDate");
    query.bindValue(":startDate", from);
    query.bindValue(":endDate", to);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return records;
    }

    while (query.next()) {

        QVariantList record;
        record << query.value(m_model->columnIndex("ID"))
               << query.value(m_model->columnIndex("title"))
               << query.value(m_model->columnIndex("date"))
               << query.value(m_model->columnIndex("time"))
               << query.value(m_model->columnIndex("reminder"))
               << query.value(m_model->columnIndex("repeatMode"))
               << query.value(m_model->columnIndex("category"))
               << query.value(m_model->columnIndex("notes"))
               << query.value(m_model->columnIndex("completed"));

        records.append(record);
    }

    std::sort(records.begin(), records.end(), [this](const QVariantList& left, const QVariantList& right) {
        return  QDateTime(left.value(m_model->columnIndex("date")).toDate(), left.value(m_model->columnIndex("time")).toTime())
        < QDateTime(right.value(m_model->columnIndex("date")).toDate(), right.value(m_model->columnIndex("time")).toTime());
    });

    return records;
}

QMap<QDate, QList<QVariantList>> DiaryExport :: groupListByDate(QList<QVariantList> list) {
    QMap<QDate, QList<QVariantList>> result;
    for (const QVariantList& element : list) {
        QDate date = element.value(m_model->columnIndex("date")).toDate();
        result[date].append(element);
    }
    return result;
}

void DiaryExport :: fileForDateExport(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, const QString& format) {

    QMap<QDate, QList<QVariantList>> dateGroups = groupListByDate(exportList);
    QString newPath = path;
    newPath.remove("\\diary" + format);

    for (auto it = dateGroups.constBegin(); it != dateGroups.constEnd(); ++it) {
        QList<QVariantList> currListByDate = it.value();
        QString currPath = newPath + QString("\\diary_%1" + format).arg(it.key().toString("yyyy-MM-dd"));

        if      (format == ".json") { exportJsonByList(currPath, currListByDate, isCompletedInclude, isOnlyUnique, isNotesInclude, false); }
        else if (format == ".txt")  { exportTxtByList (currPath, currListByDate, isCompletedInclude, isOnlyUnique, isNotesInclude, false); }
        else if (format == ".pdf")  { exportPdfByList (currPath, currListByDate, isCompletedInclude, isOnlyUnique, isNotesInclude, false); }
        else if (format == ".xml")  { exportXmlByList (currPath, currListByDate, isCompletedInclude, isOnlyUnique, isNotesInclude, false); }
    }
}

void DiaryExport :: exportJson(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {
    exportJsonByList(path + "\\diary.json", getExportList(from, to), isCompletedInclude, isOnlyUnique, isNotesInclude, isFileForDate);
}

void DiaryExport :: exportJsonByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {

    if (isFileForDate) {
        fileForDateExport(path, exportList, isCompletedInclude, isOnlyUnique, isNotesInclude, ".json");
        return;
    }

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file for writing:" << path;
        return;
    }

    QJsonArray jsonArray;
    QSet<QString> uniqueRecords;

    for (const QVariantList& element : exportList) {

        if (element.value(m_model->columnIndex("completed")).toBool() && !isCompletedInclude) {
            continue;
        }

        if (isOnlyUnique) {
            QString title = element.value(m_model->columnIndex("title")).toString();
            if (uniqueRecords.contains(title)) {
                continue;
            }
            uniqueRecords.insert(title);
        }

        QJsonObject jsonRecord;
        jsonRecord["title"]      = element.value(m_model->columnIndex("title")).toString();
        jsonRecord["date"]       = element.value(m_model->columnIndex("date")).toString();
        jsonRecord["time"]       = element.value(m_model->columnIndex("time")).toString();
        jsonRecord["reminder"]   = element.value(m_model->columnIndex("reminder")).toString();
        jsonRecord["repeatMode"] = element.value(m_model->columnIndex("repeatMode")).toString();
        jsonRecord["category"]   = element.value(m_model->columnIndex("category")).toString();

        if (isNotesInclude) {
            jsonRecord["notes"] = element.value(m_model->columnIndex("notes")).toString();
        }

        jsonArray.append(jsonRecord);
    }

    if (!jsonArray.isEmpty()) {

        QJsonObject rootObject;
        rootObject["diary"] = jsonArray;

        QJsonDocument jsonDoc(rootObject);
        QTextStream out(&file);
        out << jsonDoc.toJson(QJsonDocument::Indented);

    } else {
        file.remove();
        return;
    }

    file.close();
}

void DiaryExport :: exportTxt(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {
    exportTxtByList(path + "\\diary.txt", getExportList(from, to), isCompletedInclude, isOnlyUnique, isNotesInclude, isFileForDate);
}

void DiaryExport :: exportTxtByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {

    if (isFileForDate) {
        fileForDateExport(path, exportList, isCompletedInclude, isOnlyUnique, isNotesInclude, ".txt");
        return;
    }

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file for writing:" << path;
        return;
    }

    QTextStream out(&file);
    QSet<QString> uniqueRecords;
    bool isFileEmpty = true;

    out << "Diary\n-----\n\n";

    for (const QVariantList& element : exportList) {

        if (element.value(m_model->columnIndex("completed")).toBool() && !isCompletedInclude) {
            continue;
        }

        if (isOnlyUnique) {

            QString title = element.value(m_model->columnIndex("title")).toString();
            if (uniqueRecords.contains(title)) {
                continue;
            }
            uniqueRecords.insert(title);
        }

        out << "Title: "        << element.value(m_model->columnIndex("title")).toString()       << "\n";
        out << "Date: "         << element.value(m_model->columnIndex("date")).toString()        << "\n";
        out << "Time: "         << element.value(m_model->columnIndex("time")).toString()        << "\n";
        out << "Reminder: "     << element.value(m_model->columnIndex("reminder")).toString()    << "\n";
        out << "RepeatMode: "   << element.value(m_model->columnIndex("repeatMode")).toString()  << "\n";
        out << "Category: "     << element.value(m_model->columnIndex("category")).toString()    << "\n";

        if (isNotesInclude) {
            out << "Notes: " << element.value(m_model->columnIndex("notes")).toString() << "\n";
        }

        out << "\n";
        isFileEmpty = false;
    }

    if (isFileEmpty) {
        file.remove();
        return;
    }

    file.close();
}

void DiaryExport :: exportPdf(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {
    exportPdfByList(path + "\\diary.pdf", getExportList(from, to), isCompletedInclude, isOnlyUnique, isNotesInclude, isFileForDate);
}

void DiaryExport :: exportPdfByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {

    if (isFileForDate) {
        fileForDateExport(path, exportList, isCompletedInclude, isOnlyUnique, isNotesInclude, ".pdf");
        return;
    }

    QPdfWriter pdfWriter(path);

    pdfWriter.setPageSize(QPageSize(QPageSize::A4));
    pdfWriter.setResolution(300);

    QPainter painter(&pdfWriter);
    QFont font("Times New Roman", 24);
    font.setBold(true);
    painter.setFont(font);

    int yPosition   = 100;
    int yOffset     = 200;

    QSet<QString> uniqueRecords;

    painter.drawText(pdfWriter.width() / 2, yPosition, "Diary");
    yPosition += yOffset;

    painter.setFont(QFont("Times New Roman", 21));

    bool isFileEmpty = true;

    for (const QVariantList& element : exportList) {

        if (element.value(m_model->columnIndex("completed")).toBool() && !isCompletedInclude) {
            continue;
        }

        if (isOnlyUnique) {
            QString title = element.value(m_model->columnIndex("title")).toString();
            if (uniqueRecords.contains(title)) {
                continue;
            }
            uniqueRecords.insert(title);
        }

        painter.drawText(100, yPosition, QString("Title: %1").arg(element.value(m_model->columnIndex("title")).toString()));
        yPosition += yOffset;

        painter.drawText(100, yPosition, QString("Date: %1").arg(element.value(m_model->columnIndex("date")).toString()));
        yPosition += yOffset;

        painter.drawText(100, yPosition, QString("Time: %1").arg(element.value(m_model->columnIndex("time")).toString()));
        yPosition += yOffset;

        painter.drawText(100, yPosition, QString("Reminder: %1").arg(element.value(m_model->columnIndex("reminder")).toString()));
        yPosition += yOffset;

        painter.drawText(100, yPosition, QString("RepeatMode: %1").arg(element.value(m_model->columnIndex("repeatMode")).toString()));
        yPosition += yOffset;

        painter.drawText(100, yPosition, QString("Category: %1").arg(element.value(m_model->columnIndex("category")).toString()));
        yPosition += yOffset;

        if (isNotesInclude) {
            painter.drawText(100, yPosition, QString("Notes: %1").arg(element.value(m_model->columnIndex("notes")).toString()));
            yPosition += yOffset;
        }

        yPosition += yOffset * 2;

        if (yPosition > pdfWriter.height() - yOffset * 2) {
            pdfWriter.newPage();
            yPosition = 100;
        }

        isFileEmpty = false;
    }

    painter.end();

    if (isFileEmpty) {
        QFile file(path);
        file.remove();
        return;
    }
}

void DiaryExport :: exportXml(const QString& path, const QDate& from, const QDate& to, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {
    exportXmlByList(path + "\\diary.xml", getExportList(from, to), isCompletedInclude, isOnlyUnique, isNotesInclude, isFileForDate);
}

void DiaryExport :: exportXmlByList(const QString& path, QList<QVariantList> exportList, bool isCompletedInclude, bool isOnlyUnique, bool isNotesInclude, bool isFileForDate) {

    if (isFileForDate) {
        fileForDateExport(path, exportList, isCompletedInclude, isOnlyUnique, isNotesInclude, ".xml");
        return;
    }

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Failed to open file for writing";
        return;
    }

    QXmlStreamWriter xmlWriter(&file);
    xmlWriter.setAutoFormatting(true);
    xmlWriter.writeStartDocument();
    xmlWriter.writeStartElement("Diary");

    QSet<QString> uniqueRecords;
    bool isFileEmpty = true;

    for (const QVariantList& element : exportList) {

        if (element.value(m_model->columnIndex("completed")).toBool() && !isCompletedInclude) {
            continue;
        }

        if (isOnlyUnique) {

            QString title = element.value(m_model->columnIndex("title")).toString();
            if (uniqueRecords.contains(title)) {
                continue;
            }
            uniqueRecords.insert(title);
        }

        xmlWriter.writeStartElement("Record");
        xmlWriter.writeTextElement("Title",         element.value(m_model->columnIndex("title")).toString());
        xmlWriter.writeTextElement("Date",          element.value(m_model->columnIndex("date")).toString());
        xmlWriter.writeTextElement("Time",          element.value(m_model->columnIndex("time")).toString());
        xmlWriter.writeTextElement("Reminder",      element.value(m_model->columnIndex("reminder")).toString());
        xmlWriter.writeTextElement("RepeatMode",    element.value(m_model->columnIndex("repeatMode")).toString());
        xmlWriter.writeTextElement("Category",      element.value(m_model->columnIndex("category")).toString());

        if (isNotesInclude) {
            xmlWriter.writeTextElement("Notes",     element.value(m_model->columnIndex("notes")).toString());
        }

        xmlWriter.writeEndElement();
        isFileEmpty = false;
    }

    if (isFileEmpty) {
        file.remove();
        return;
    }

    xmlWriter.writeEndElement();
    xmlWriter.writeEndDocument();

    file.close();
}
