import QtQuick 2.5
import palette 1.0
import "qrc:/components"

Rectangle {
    id: main;
    property bool onPage;
    signal finished();

    Item {
        layer.enabled: true;
        visible: main.onPage;
        anchors {
            fill: parent;
            topMargin: App.toolbar.height
            bottomMargin: bottomRow.height;
        }

        Column {
            width: parent.width - 20*ap;
            spacing: 20*ap;
            anchors { centerIn: parent; }

            Text {
                text: "What is Ultimate Tic Tac Toe?";
                wrapMode: Text.WordWrap;
                width: parent.width*0.9
                font.pixelSize: 50*ap;
                font.weight: Font.Normal;
                horizontalAlignment: Text.AlignHCenter;
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Text {
                width: Math.min(parent.width*0.9, 800*ap);
                wrapMode: Text.WordWrap;
                horizontalAlignment: Text.AlignHCenter;
                anchors { horizontalCenter: parent.horizontalCenter; }
                font.pixelSize: 30*ap;
                text: "Ultimate tic tac toe is a fun twist on the classic game of tic tac toe that contains "
                    + "9 tic tac toe boards inside one big tic tac toe board"
            }

            Item { width: 1; height: 1 } //spacing

            ColoredImage {
                opacity: 0.8;
                image.source: "qrc:/img/tictactoe.png";
                image.sourceSize: Qt.size(width, height);
                width: Math.min(main.width*0.9, main.height*0.6);
                height: width;
                anchors { horizontalCenter: parent.horizontalCenter; }

                Grid {
                    rows: 3; columns: 3;
                    anchors { fill: parent; }

                    Repeater {
                        model: 9;
                        Item {
                            width: parent.width/parent.columns;
                            height: parent.height/parent.rows;
                            ColoredImage {
                                image.source: "qrc:/img/tictactoe.png";
                                image.sourceSize: Qt.size(width, height);
                                anchors { fill: parent; margins: parent.width*0.2; }
                            }
                        }

                    }
                }
            }
        }
    }

    Component.onCompleted: finished();
}

