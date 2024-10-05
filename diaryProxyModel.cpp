#include "diaryProxyModel.h"
#include "diaryModel.h"

DiaryProxyModel :: DiaryProxyModel(QObject* parent) : QSortFilterProxyModel(parent), m_filterType(None)
{ }

void DiaryProxyModel :: setFilterTitle(const QString& title) {
    m_filterTitle = title;
    m_filterType = TitleFilter;
    invalidateFilter();
}

void DiaryProxyModel :: setFilterDate(const QDate& date) {
    m_filterDate = date;
    m_filterType = DateFilter;
    invalidateFilter();
}

void DiaryProxyModel :: setFilterCategory(const QString& category) {

    if (category == "Without category") {
        clearFilter();
        return;
    }

    m_filterCategory = category;
    m_filterType = CategoryFilter;
    invalidateFilter();
}

void DiaryProxyModel :: clearFilter() {
    m_filterType = None;
    invalidateFilter();
}

bool DiaryProxyModel :: filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const {

    DiaryModel* source = static_cast<DiaryModel*>(sourceModel());

    if (m_filterType == DateFilter) {

        QModelIndex dateIndex       = source->index(sourceRow, source->columnIndex("date"), sourceParent);
        QModelIndex completedIndex  = source->index(sourceRow, source->columnIndex("completed"), sourceParent);

        QDate       recordDate      = source->data(dateIndex).toDate();
        bool        recordCompleted = source->data(completedIndex).toBool();
        return ((recordDate == m_filterDate) && !recordCompleted);

    } else if (m_filterType == CategoryFilter) {

        QModelIndex index = source->index(sourceRow, source->columnIndex("category"), sourceParent);
        QString recordCategory = source->data(index).toString();
        return (recordCategory == m_filterCategory);

    } else if (m_filterType == TitleFilter) {

        QModelIndex index = source->index(sourceRow, source->columnIndex("title"), sourceParent);
        QString recordTitle = source->data(index).toString();
        return (recordTitle == m_filterTitle);
    }

    return true;
}

bool DiaryProxyModel :: lessThan(const QModelIndex& left, const QModelIndex& right) const {

    int column = left.column();

    if (sourceModel()->headerData(column, Qt::Horizontal) == "date") {

        QDate leftDate = sourceModel()->data(sourceModel()->index(left.row(), column)).toDate();
        QTime leftTime = sourceModel()->data(sourceModel()->index(left.row(), column + 1)).toTime();
        QDateTime leftDateTime(leftDate, leftTime);

        QDate rightDate = sourceModel()->data(sourceModel()->index(right.row(), column)).toDate();
        QTime rightTime = sourceModel()->data(sourceModel()->index(right.row(), column + 1)).toTime();
        QDateTime rightDateTime(rightDate, rightTime);

        return leftDateTime < rightDateTime;
    }
    else if (sourceModel()->headerData(column, Qt::Horizontal) == "title") {
        QString leftTitle  = sourceModel()->data(left).toString();
        QString rightTitle = sourceModel()->data(right).toString();

        return QString::localeAwareCompare(leftTitle, rightTitle) < 0;
    }
    else if (sourceModel()->headerData(column, Qt::Horizontal) == "notes") {
        QString leftNotes  = sourceModel()->data(left).toString();
        QString rightNotes = sourceModel()->data(right).toString();

        return leftNotes.length() < rightNotes.length();
    }

    return QSortFilterProxyModel::lessThan(left, right);
}
