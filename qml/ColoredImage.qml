import QtQuick 2.5
import QtGraphicalEffects 1.0
import palette 1.0

Item {
    id: main;

    property var hsla: Color.hsla(color);
    property alias image: image;
    property alias overlay: overlay;
    property color color: Palette.theme.primaryText;
    property Item maskSource: Item{ parent: main; }

    Image {
        id: image;
        asynchronous: true;
        anchors { fill: parent; }
        sourceSize: Qt.size(width, height)
        visible: false
    }

    Colorize {
        id: overlay;
        source: image;
        hue: hsla.h;
        saturation: hsla.s;
        lightness: hsla.l;
        opacity: hsla.a;
        cached: true;
        anchors { fill: image; }
        visible: image.status == Image.Ready;
    }
}

