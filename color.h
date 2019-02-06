#ifndef COLOR
#define COLOR

#include <QObject>
#include <QColor>
#include <QJsonObject>
#include <QDebug>
#include <qmath.h>

class Color : public QObject
{
    Q_OBJECT
public:
    Color() {}

    Q_INVOKABLE QColor fromString(const QString &string) {
        return QColor(string);
    }

    Q_INVOKABLE QColor setAlpha(const QString &string, double alphaLevel) {
        QColor color = QColor(string);
        color.setAlphaF(alphaLevel);
        return color;
    }

    Q_INVOKABLE QColor addAlpha(const QString &string, double alpha) {
        QColor color = QColor(string);
        color.setAlphaF(qMin<double>(1, qMax<double>(0, color.alphaF() - alpha)));
        return color;
    }

    Q_INVOKABLE QColor average(const QString &str1, const QString &str2) {
        QColor c1 = QColor(str1);
        QColor c2 = QColor(str2);
        int r = (c1.red() + c2.red())*0.5;
        int g = (c1.green() + c2.green())*0.5;
        int b = (c1.blue() + c2.blue())*0.5;
        int a = (c1.alpha() + c2.alpha())*0.5;

        return QColor(r, g, b, a);
    }

    Q_INVOKABLE QColor invert(const QString &str) {
        QColor color = QColor(str);
        color.setRedF(1 - color.redF());
        color.setGreenF(1 - color.greenF());
        color.setBlueF(1 - color.blueF());
        return color;
    }

    Q_INVOKABLE QJsonObject hsla(const QString &str) {
        QColor color(str);
        QJsonObject hsla;
        hsla.insert("h", color.hslHueF());
        hsla.insert("s", color.hslSaturationF());
        hsla.insert("l", color.lightnessF());
        hsla.insert("a", color.alphaF());
        return hsla;
    }
};

#endif // COLOR

