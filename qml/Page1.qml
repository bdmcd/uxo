import QtQuick 2.5
import "qrc:/components"

Rectangle {
    id: main;
    property bool onPage;
    property bool ready;
    signal finished();

    Item {
        visible: main.onPage;
        anchors {
            fill: parent;
            topMargin: App.toolbar.height
            bottomMargin: bottomRow.height;
        }

        Column {
            anchors { centerIn: parent; verticalCenterOffset: -30*ap; }

            LogoText {
                font.pixelSize: 180*ap;
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Text {
                font.pixelSize: 40*ap;
                text: "Ultimate Tic Tac Toe";
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Item { width: 1; height: main.height*0.2; } //spacing

            Row {
                spacing: 10*ap;
                anchors { horizontalCenter: parent.horizontalCenter; }

                Text {
                    font.pixelSize: 35*ap;
                    text: ready ? "Swipe to learn how to play" : "Loading...";
                    anchors { verticalCenter: parent.verticalCenter; }
                }

                ColoredImage {
                    width: height;
                    height: parent.height - 2;
                    image.source: "qrc:/img/forward.png";
                    anchors { verticalCenter: parent.verticalCenter; }
                    visible: ready;
                }
            }
        }
    }

    Component.onCompleted: finished();
}

