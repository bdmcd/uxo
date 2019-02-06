import QtQuick 2.5
import QtQuick.Layouts 1.1
import palette 1.0
import "qrc:/components"

Rectangle {
    id: main;
    enabled: tutorial ? tutorialEnabled && state == '' : state == '';
    border.width: showBorder ? Math.max(width*0.05, 1) : 0;
    border.color: color

    property int boardIndex;
    property int squareIndex;
    property bool tutorial: false;
    property bool tutorialEnabled: false;
    property color borderColor: Color.setAlpha("red", 0.5);
    property bool showBorder: enabled && tutorialEnabled && state == '';
    onShowBorderChanged: anim.updateRunning();

    Loader {
        id: imageLoader;
        anchors { fill: parent; margins: main.width*0.1; }
        property var binding: {
            var letter = main.state.toUpperCase();
            if (letter == "X" || letter == "O") {
                setSource("qrc:/components/" + letter + ".qml");;
            }
            else {
                setSource("");
            }
        }
    }

    SequentialAnimation on border.color {
        id: anim; loops: Animation.Infinite;
        ColorAnimation { from: main.color; to: main.borderColor; duration: 700; }
        ColorAnimation { from: main.borderColor; to: main.color; duration: 1000; }
        PauseAnimation { duration: 500; }

        function updateRunning() {
            if (showBorder) {
                wait(squareIndex*50, function() { running = showBorder; })
            }
            running = false;
        }
    }
}
