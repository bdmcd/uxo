import QtQuick 2.5
import palette 1.0
import "qrc:/components"

Rectangle {
    id: main;
    property bool onPage;
    signal finished();

    Item {
        visible: main.onPage;
        anchors {
            fill: parent;
            topMargin: App.toolbar.height
            bottomMargin: bottomRow.height;
        }

        Column {
            spacing: 5*ap;
            anchors { centerIn: parent; verticalCenterOffset: -30*ap; }

            Text {
                font.pixelSize: 80*ap;
                text: "Congratulations!";
                font.weight: Font.Normal;
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Item { width: 1; height: 40*ap; } //spacing;

            Text {
                font.pixelSize: 30*ap;
                text: "You now know how to play";
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Text {
                font.pixelSize: 35*ap;
                text: "Ultimate Tic Tac Toe";
                font.weight: Font.Normal;
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Item { width: 1; height: main.height*0.2; } //spacing

            Button {
                width: 300*ap;
                height: 80*ap;
                opacity: 1;
                color: Qt.darker(main.color, 1.2);
                pressedColor: Color.setAlpha(color, 0.3);
                anchors { horizontalCenter: parent.horizontalCenter; }
                onClicked: App.view.goBack();

                Text {
                    font.pixelSize: parent.height*0.35;
                    text: "Get Started";
                    anchors { centerIn: parent; }
                }
            }
        }
    }

    Component.onCompleted: finished();
}

