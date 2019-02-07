#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QtQml>

#include "qmlglobals.h"
#include "fileio.h"
#include "color.h"
#include "settings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QFontDatabase::addApplicationFont(":/font/GillSans-Bold.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-BoldItalic.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-Italic.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-Light.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-LightItalic.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-SemiBoldItalic.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans-UltraBold.ttf");
    QFontDatabase::addApplicationFont(":/font/GillSans.ttf");

    app.setFont(QFont("Gill Sans", -1, QFont::Light));

    QmlGlobals qmlGlobals;
    FileIO fileIO;
    Settings settings;
    Color color;

    qmlRegisterSingletonType(QUrl("qrc:/palette.qml"), "palette", 1, 0, "Palette");
    engine.rootContext()->setContextObject(&qmlGlobals);
    engine.rootContext()->setContextProperty("FileIO", &fileIO);
    engine.rootContext()->setContextProperty("Settings", &settings);
    engine.rootContext()->setContextProperty("Color", &color);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

