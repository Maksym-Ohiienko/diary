#include "diaryModel.h"

DiaryModel :: DiaryModel(QObject* parent, QSqlDatabase db)
    : QSqlRelationalTableModel(parent, db)
{
    setTable("Record");
    setEditStrategy(QSqlTableModel::OnFieldChange);
    select();

    m_jsonManager       = new CategoryManager;
    m_completedCount    = countCompletedRecords();
    m_activeCount       = countActiveRecords();

    m_proxyModel = new DiaryProxyModel;
    m_proxyModel->setSourceModel(this);
}

void DiaryModel :: sortRecords(const QString& sortFactor) {

    if (sortFactor == "Deadline(ASC)") {
        m_proxyModel->sort(columnIndex("date"), Qt::AscendingOrder);
    }
    else if (sortFactor == "Deadline(DESC)") {
        m_proxyModel->sort(columnIndex("date"), Qt::DescendingOrder);
    }
    else if (sortFactor == "Notes dimension(ASC)") {
        m_proxyModel->sort(columnIndex("notes"), Qt::AscendingOrder);
    }
    else if (sortFactor == "Notes dimension(DESC)") {
        m_proxyModel->sort(columnIndex("notes"), Qt::DescendingOrder);
    }
    else if (sortFactor == "Alphabet(ASC)") {
        m_proxyModel->sort(columnIndex("title"), Qt::AscendingOrder);
    }
    else if (sortFactor == "Alphabet(DESC)") {
        m_proxyModel->sort(columnIndex("title"), Qt::DescendingOrder);
    }
}

void DiaryModel :: addItem(const QString& title, const QDate& date, const QTime& time, const QString& reminder, const QString& repeatMode,
                       const QString& category, const QString& notes, bool completed) {

    QSqlQuery query(this->database());

    query.prepare("INSERT INTO Record (title, date, time, reminder, repeatMode, category, notes, completed, DIARY_ID)"
                  "VALUES (:title, :date, :time, :reminder, :repeatMode, :category, :notes, :completed, :diary_id)");

    query.bindValue(":title", title);
    query.bindValue(":date", date.toString(Qt::ISODate));
    query.bindValue(":time", time.toString("HH:mm"));
    query.bindValue(":reminder", reminder == "Empty" ? QVariant() : reminder);
    query.bindValue(":repeatMode", repeatMode);
    query.bindValue(":category", category);
    query.bindValue(":notes", notes);
    query.bindValue(":completed", completed);
    query.bindValue(":diary_id", 0);

    if (!query.exec()) {
        qDebug() << "Failed to add item:" << query.lastError().text();
    } else {
        this->select();
        this->updateCounts();
    }
}

void DiaryModel :: offReminders() {

    QSqlQuery query(this->database());

    query.prepare("UPDATE Record SET reminder = :reminder WHERE reminder IS NOT NULL");

    query.bindValue(":reminder", QVariant());

    if (!query.exec()) {
        qDebug() << "Failed to update item:" << query.lastError().text();
    }
    else {
        this->select();
    }
}

void DiaryModel :: updateItem(const QString& title, const QDate& date, const QTime& time, const QString& reminder, const QString& repeatMode,
                          const QString& category, const QString& notes, bool completed, int id) {

    QSqlQuery query(this->database());

    query.prepare("UPDATE Record SET title = :title, date = :date, time = :time, reminder = :reminder, repeatMode = :repeatMode, category = :category, notes = :notes,"
                  "completed = :completed WHERE id = :id");

    query.bindValue(":title", title);
    query.bindValue(":date", date.toString(Qt::ISODate));
    query.bindValue(":time", time.toString("HH:mm"));
    query.bindValue(":reminder", reminder == "Empty" ? QVariant() : reminder);
    query.bindValue(":repeatMode", repeatMode);
    query.bindValue(":category", category);
    query.bindValue(":notes", notes);
    query.bindValue(":completed", completed);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qDebug() << "Failed to update item:" << query.lastError().text();
    } else {
        this->select();
        this->updateCounts();
    }
}

void DiaryModel :: removeItem(int id) {

    QSqlQuery query(this->database());

    query.prepare("DELETE FROM Record WHERE id = :id");
    query.bindValue(":id", id);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return;
    }

    this->select();
    this->updateCounts();
}

bool DiaryModel :: haveRecordsAtDate(const QDate& date) const {

    QSqlQuery query(this->database());

    query.prepare("SELECT date FROM Record WHERE date = :date AND completed = false");
    query.bindValue(":date", date);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return false;
    }

    return query.next();
}

bool DiaryModel :: isRecordExists(int id) const {

    QSqlQuery query(this->database());

    query.prepare("SELECT id FROM Record WHERE id = :id");
    query.bindValue(":id", id);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return false;
    }

    return query.next();
}

int DiaryModel :: countCompletedRecords() const {

    QSqlQuery query(this->database());

    query.prepare("SELECT COUNT(*) FROM Record WHERE completed = :completed");
    query.bindValue(":completed", true);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return -1;
    }

    if (query.next()) {
        return query.value(0).toInt();
    } else {
        qDebug() << "No results found.";
        return -1;
    }
}

int DiaryModel :: countActiveRecords() const {

    return this->rowCount() - countCompletedRecords();
}

void DiaryModel :: updateCounts() {

    m_completedCount    = countCompletedRecords();
    m_activeCount       = countActiveRecords();

    emit completedCountChanged();
    emit activeCountChanged();
}

void DiaryModel :: clearCompletedRecords() {

    QSqlQuery query(this->database());

    query.prepare("DELETE FROM Record WHERE completed = :completed");
    query.bindValue(":completed", true);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return;
    }

    this->select();
    this->updateCounts();
}

int DiaryModel :: countActiveByCategory(const QString& category) const {

    QSqlQuery query(this->database());

    query.prepare("SELECT COUNT(*) FROM Record WHERE category = :category AND completed = :completed");

    query.bindValue(":category", category);
    query.bindValue(":completed", false);

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return -1;
    }

    if (query.next()) {
        return query.value(0).toInt();
    } else {

        qDebug() << "No results found.";
        return -1;
    }
}

CategoryManager* DiaryModel :: jsonManager() const {
    return m_jsonManager;
}

int DiaryModel :: completedCount() const {
    return m_completedCount;
}

int DiaryModel :: activeCount() const {
    return m_activeCount;
}

QSortFilterProxyModel* DiaryModel :: proxyModel() const {
    return m_proxyModel;
}

QHash<int, QByteArray> DiaryModel :: roleNames() const {

    QHash<int, QByteArray> roles = QAbstractTableModel::roleNames();

    for (int i = 0; i < this->columnCount(); ++i) {
        roles.insert(Qt::UserRole + i, this->headerData(i, Qt::Horizontal).toByteArray());
    }

    return roles;
}

int DiaryModel :: columnIndex(const QString& columnName) const {

    for (int i = 0; i < this->columnCount(); ++i) {
        if (this->headerData(i, Qt::Horizontal).toString() == columnName) {
            return i;
        }
    }
    return -1;
}

QVariant DiaryModel :: data(const QModelIndex &index, int role) const {
    if (!index.isValid()) {
        return QVariant();
    }

    if (role >= Qt::UserRole) {
        return data(this->index(index.row(), role - Qt::UserRole), Qt::DisplayRole);
    }

    return QSqlRelationalTableModel::data(index, role);
}

QVariantList DiaryModel :: getByCategoryUniqueList() const {

    QVariantList result;
    QMap<QString, bool> addedCategories;

    QSqlQuery query(this->database());
    query.prepare("SELECT DISTINCT category FROM Record");

    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return result;
    }

    while (query.next()) {
        QString category = query.value(0).toString();

        if (!addedCategories.contains(category)) {

            QString color = m_jsonManager->getColorForCategory(category);

            int count = countActiveByCategory(category);

            QVariantMap info;
            info["category"] = category;
            info["color"] = color;
            info["count"] = count;

            result.append(info);

            addedCategories.insert(category, true);
        }
    }

    return result;
}
