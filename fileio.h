#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = 0);

    Q_INVOKABLE QString read(const QString &filename);
    Q_INVOKABLE bool write(const QString &filename, const QString &data);
    Q_INVOKABLE bool exists(const QString &filename);
    Q_INVOKABLE bool remove(const QString &filename);
    Q_INVOKABLE QString gameDirectory();
};

#endif // FILEIO_H
