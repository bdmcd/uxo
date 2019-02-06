#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QDebug>
#include <QDesktopServices>
#include <QStandardPaths>

class Settings : public QSettings
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0) : QSettings(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.ini", QSettings::IniFormat, parent) {
    }

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value) {
        QSettings::setValue(key, value);
    }

    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) {
        return QSettings::value(key, defaultValue);
    }
};

#endif // SETTINGS_H
