#ifndef DIARYPROXYMODEL_H
#define DIARYPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QObject>
#include <QDate>
#include <QTime>
#include <QDateTime>

class DiaryProxyModel : public QSortFilterProxyModel {
    Q_OBJECT

public:
    explicit DiaryProxyModel(QObject* parent = nullptr);

    Q_INVOKABLE void setFilterTitle(const QString& title);
    Q_INVOKABLE void setFilterDate(const QDate& date);
    Q_INVOKABLE void setFilterCategory(const QString& category);
    Q_INVOKABLE void clearFilter();

protected:
    bool lessThan(const QModelIndex& left, const QModelIndex& right)        const override;
    bool filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent)   const override;

private:
    enum FilterType {
        None,
        DateFilter,
        CategoryFilter,
        TitleFilter
    };

    FilterType  m_filterType;
    QDate       m_filterDate;
    QString     m_filterCategory;
    QString     m_filterTitle;
};

#endif // DIARYPROXYMODEL_H
