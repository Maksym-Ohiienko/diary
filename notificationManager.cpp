#include "notificationManager.h"

NotificationManager :: NotificationManager(QObject* parent) : QObject(parent) {

    m_mainWindowVisible = true;

    m_trayIcon = new QSystemTrayIcon(this);
    m_trayIcon->setIcon(QIcon(":/images/MainWindowIcon/diary.ico"));
    m_trayIcon->setVisible(true);

    QMenu* trayMenu = new QMenu;

    QAction* showAction = new QAction("Show");

    QFont boldFont = showAction->font();
    boldFont.setBold(true);
    showAction->setFont(boldFont);

    QAction* exitAction = new QAction("Exit");

    connect(m_trayIcon, &QSystemTrayIcon::activated, this, &NotificationManager::onTrayIconActivated);
    connect(showAction, &QAction::triggered, this, &NotificationManager::onShowWindow);
    connect(exitAction, &QAction::triggered, QApplication::instance(), &QApplication::quit);

    trayMenu->addAction(showAction);
    trayMenu->addAction(exitAction);

    m_trayIcon->setContextMenu(trayMenu);
    m_trayIcon->setToolTip("Diary");
}

int NotificationManager :: mainWindowVisible() const {
    return m_mainWindowVisible;
}

void NotificationManager :: onMainWindowClosing() {
    m_mainWindowVisible = false;
    emit mainWindowVisibleChanged();
}

void NotificationManager :: onTrayIconActivated(QSystemTrayIcon::ActivationReason reason) {
    if (reason == QSystemTrayIcon::Trigger) {
        onShowWindow();
    }
}

void NotificationManager :: onShowWindow() {
    m_mainWindowVisible = !m_mainWindowVisible;
    emit mainWindowVisibleChanged();
}

void NotificationManager :: sendNotification(const QString& title, const QString& message) {
    m_trayIcon->showMessage(title, message, QSystemTrayIcon::Information, 3000);
}

