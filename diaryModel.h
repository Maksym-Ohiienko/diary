#ifndef DIARYMODEL_H
#define DIARYMODEL_H

#include <QSqlRelationalTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include "categoryManager.h"
#include "diaryProxyModel.h"

class DiaryModel : public QSqlRelationalTableModel
{
    Q_OBJECT
    Q_PROPERTY(int completedCount   READ completedCount NOTIFY completedCountChanged)
    Q_PROPERTY(int activeCount      READ activeCount    NOTIFY activeCountChanged)

public:
    explicit DiaryModel(QObject* parent, QSqlDatabase db);

    Q_INVOKABLE void sortRecords(const QString& sortFactor);

    Q_INVOKABLE void addItem    (const QString& title, const QDate& date, const QTime& time, const QString& reminder, const QString& repeatMode,
                                    const QString& category, const QString& notes, bool completed);

    Q_INVOKABLE void updateItem (const QString& title, const QDate& date, const QTime& time, const QString& reminder, const QString& repeatMode,
                                    const QString& category, const QString& notes, bool completed, int id);

    Q_INVOKABLE void removeItem (int id);

    Q_INVOKABLE QVariantList getByCategoryUniqueList() const;

    Q_INVOKABLE void    updateCounts();
    Q_INVOKABLE void    clearCompletedRecords();
    Q_INVOKABLE void    offReminders();

    CategoryManager*    jsonManager()                                   const;
    int                 countActiveByCategory(const QString& category)  const;
    int                 countCompletedRecords()                         const;
    int                 countActiveRecords()                            const;
    Q_INVOKABLE bool    isRecordExists(int id)                          const;
    Q_INVOKABLE bool    haveRecordsAtDate(const QDate& date)            const;
    Q_INVOKABLE int     columnIndex(const QString& columnName)          const;
    Q_INVOKABLE int     completedCount()                                const;
    Q_INVOKABLE int     activeCount()                                   const;
    Q_INVOKABLE QSortFilterProxyModel* proxyModel()                     const;

    QHash<int, QByteArray> roleNames()                                  const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

signals:
    void completedCountChanged();
    void activeCountChanged();

private:
    CategoryManager*        m_jsonManager;
    int                     m_completedCount;
    int                     m_activeCount;
    DiaryProxyModel*        m_proxyModel;
};

#endif // DIARYMODEL_H
