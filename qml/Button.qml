import QtQuick 2.5
import palette 1.0

MouseArea {
    id: main;
    width: 10;
    height: 10;
    opacity: containsPress || selected ? pressedOpacity : releasedOpacity;
    Behavior on opacity { PropertyAnimation { duration: 100; } }

    property bool selected: false;
    property color color: "transparent";
    property color pressedColor: color;
    property double releasedOpacity: 1.0;
    property double pressedOpacity: 0.6
    property alias radius: background.radius;

    Rectangle {
        id: background;
        radius: height*0.1;
        anchors { fill: parent }
        color: main.containsPress || main.selected ? main.pressedColor : main.color;
        Behavior on color { PropertyAnimation { duration: 100; } }
    }
}

