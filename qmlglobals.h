#ifndef QMLGLOBALS
#define QMLGLOBALS

#include <QQuickItem>
#include <QJSValue>
#include <QTimer>
#include <QDebug>
#include <QtMath>

class QmlGlobals : public QObject {
    Q_OBJECT
public:
    QmlGlobals(){}

    Q_INVOKABLE void wait(int ms, QJSValue callback) {
        QTimer::singleShot(ms, [callback]() mutable {
            callback.call();
        });
    }

    QQuickItem* app() { return _app; }
    void setApp(QQuickItem *app) { _app = app; }
    Q_PROPERTY(QQuickItem* App READ app WRITE setApp NOTIFY appChanged)

    QJSValue screenSize() { return _screenSize; }
    double width() { return _screenSize.property("width").toNumber(); }
    double height() { return _screenSize.property("height").toNumber(); }
    double mm() { return _screenSize.property("pixelDensity").toNumber(); }
    double sp() { return qSqrt(width()*height())*0.001; }
    double dp() { return (sp()*4 + mm())*0.1; }
    double ap() { return qMin(dp(), sp()); }

    void setScreenSize(const QJSValue &size) { _screenSize = size; emit screenSizeChanged(); }

    Q_PROPERTY(QJSValue screenSize READ screenSize WRITE setScreenSize NOTIFY screenSizeChanged)
    Q_PROPERTY(double sp READ sp NOTIFY screenSizeChanged)
    Q_PROPERTY(double dp READ dp NOTIFY screenSizeChanged)
    Q_PROPERTY(double ap READ ap NOTIFY screenSizeChanged)

private:
    QQuickItem *_app;
    QJSValue _screenSize;

signals:
    void appChanged();
    void screenSizeChanged();
};

#endif // QMLGLOBALS

