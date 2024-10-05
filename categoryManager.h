#ifndef CATEGORYMANAGER_H
#define CATEGORYMANAGER_H

#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QHash>
#include <QString>
#include <QVariantList>

// mb singleton
class CategoryManager : public QObject
{
    Q_OBJECT

public:
    explicit CategoryManager(QObject *parent = nullptr);

    QString getColorForCategory(const QString &categoryName) const;
    void    loadCategories(const QString &filePath);

    Q_INVOKABLE QVariantList categoryList() const;

private:
    QHash<QString, QString> m_categoriesHash;
};

#endif // CATEGORYMANAGER_H
