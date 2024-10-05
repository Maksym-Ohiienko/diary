#include "categoryManager.h"
#include <QDebug>

CategoryManager :: CategoryManager(QObject *parent)
    : QObject(parent)
{
    loadCategories(":/json/JSON/categories.json");
}

void CategoryManager :: loadCategories(const QString &filePath) {

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file:" << file.errorString();
        return;
    }

    QByteArray jsonData = file.readAll();
    file.close();

    QJsonDocument jsonDoc(QJsonDocument::fromJson(jsonData));
    if (jsonDoc.isNull()) {
        qDebug() << "Failed to parse JSON.";
        return;
    }

    QJsonObject jsonObject = jsonDoc.object();
    QJsonArray categoriesArray = jsonObject["categories"].toArray();

    m_categoriesHash.clear();

    for (const QJsonValue& value : categoriesArray) {

        QJsonObject categoryObject = value.toObject();
        QString category = categoryObject["category"].toString();
        QString color = categoryObject["color"].toString();

        m_categoriesHash.insert(category, color);
    }
}

QString CategoryManager :: getColorForCategory(const QString& categoryName) const {
    return m_categoriesHash.value(categoryName, QString());
}

QVariantList CategoryManager :: categoryList() const {

    QVariantList list;

    for (auto it = m_categoriesHash.constBegin(); it != m_categoriesHash.constEnd(); ++it) {

        QVariantMap item;
        item["category"] = it.key();
        item["color"] = it.value();

        if (it.key() == "Without category") {
            list.prepend(item);
        } else {
            list.append(item);
        }
    }

    return list;
}

