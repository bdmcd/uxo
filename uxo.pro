TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    fileio.cpp

RESOURCES += \
    qml/qml.qrc \
    js/js.qrc \
    img/img.qrc \
    font/font.qrc \
    tutorials/tutorials.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    qmlglobals.h \
    color.h \
    fileio.h \
    settings.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

#ios {
#    QMAKE_INFO_PLIST = ios/Info.plist
#}
