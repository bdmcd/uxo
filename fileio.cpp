#include "fileio.h"
#include <QDir>
#include <QTextStream>
#include <QDebug>

FileIO::FileIO(QObject *parent) : QObject(parent)
{
    QDir dir;
    if (!dir.exists("games")) {
        dir.mkdir("games");
    }
}

QString FileIO::gameDirectory() {
    QDir dir;
    dir.cd("games");
    return dir.absolutePath();
}

QString FileIO::read(const QString &filename)
{
    QFile file(filename);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        return in.readAll();
    }
    return QString();
}

bool FileIO::write(const QString &filename, const QString &data)
{
    QFile file(filename);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << data;
        file.close();
        return true;
    }
    file.close();
    return false;
}

bool FileIO::exists(const QString &filename) {
    QFile file(filename);
    return file.exists();
}

bool FileIO::remove(const QString &filename) {
    QFile file(filename);
    return file.remove();
}
