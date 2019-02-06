import QtQuick 2.5
import QtQuick.Layouts 1.1
import palette 1.0;

Button {
    id: main;
    color: "transparent";
    pressedColor: color;

    ColumnLayout {
        anchors { fill: parent; margins: main.height*0.3; }

        Repeater {
            model: 3;

            Item {
                Layout.fillWidth: true;
                Layout.fillHeight: true;

                Rectangle {
                    anchors { centerIn: parent; }
                    width: 5*dp;
                    height: width;
                    radius: width;
                    color: App.view.toolbarForegroundColor;
                    opacity: main.containsPress ? 0.5 : 1;
                }
            }
        }
    }
}

