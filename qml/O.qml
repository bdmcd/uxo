import QtQuick 2.5
import palette 1.0

ColoredImage {
    image.source: "qrc:/img/o.png";
    image.sourceSize: Qt.size(width, height)
    image.asynchronous: true;
    color: Palette.oColor;
}
