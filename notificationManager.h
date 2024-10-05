#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QSystemTrayIcon>
#include <QMessageBox>
#include <QMenu>
#include <QAction>
#include <QApplication>

class NotificationManager : public QObject {

    Q_OBJECT
    Q_PROPERTY(bool mainWindowVisible READ mainWindowVisible NOTIFY mainWindowVisibleChanged)

public:
    explicit NotificationManager(QObject* parent = nullptr);

    Q_INVOKABLE int  mainWindowVisible() const;
    Q_INVOKABLE void onMainWindowClosing();
    Q_INVOKABLE void sendNotification(const QString& title, const QString& message);
    void onTrayIconActivated(QSystemTrayIcon::ActivationReason reason);
    void onShowWindow();

signals:
    void mainWindowVisibleChanged();

private:
    QSystemTrayIcon*    m_trayIcon;
    bool                m_mainWindowVisible;
};

#endif // NOTIFICATIONMANAGER_H
