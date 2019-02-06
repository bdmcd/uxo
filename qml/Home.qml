import QtQuick 2.5
import palette 1.0
import "qrc:/components"

View {
    id: main;
    name: "Home";
    showToolbar: false;

    property color contentColor: Palette.theme.primaryText;

    MouseArea {
        id: mouse;
        anchors.fill: parent;
    }

    Column {
        spacing: main.height*0.1;
        anchors {
            horizontalCenter: parent.horizontalCenter;
            top: parent.top;
            topMargin: Math.min((parent.width - width), (parent.height - height))*0.45;
        }

        Column {
            anchors { horizontalCenter: parent.horizontalCenter; }

            LogoText {
                id: logo;
                font.pixelSize: Math.min(main.height*0.3, 200*sp);
                color: contentColor;
                font.weight: Font.Normal;
                opacity: 0.8;
                anchors { horizontalCenter: parent.horizontalCenter; }
            }

            Text {
                text: "Ultimate Tic Tac Toe"
                font.family: "Gill Sans"
                font.pixelSize: logo.font.pixelSize*0.15;
                anchors { horizontalCenter: parent.horizontalCenter; }
                color: contentColor;
            }
        }


        Column {
            spacing: main.height*0.01;
            anchors { horizontalCenter: parent.horizontalCenter; }

            Button {
                width: main.width*0.5;
                height: Math.min(main.height*0.1, 100*sp);
                anchors { horizontalCenter: parent.horizontalCenter; }
                releasedOpacity: 0.6;
                pressedOpacity: 0.3;
                onClicked: App.changeView("Play");

                Text {
                    text: "Play";
                    font.pixelSize: parent.height*0.5;
                    anchors { centerIn: parent; }
                    color: contentColor;
                }
            }

            Button {
                width: main.width*0.5;
                height: Math.min(main.height*0.1, 100*sp);
                anchors { horizontalCenter: parent.horizontalCenter; }
                releasedOpacity: 0.6;
                pressedOpacity: 0.3;
                onClicked: App.changeView("Help");

                Text {
                    text: "How to Play";
                    font.pixelSize: parent.height*0.5;
                    anchors { centerIn: parent; }
                    color: contentColor;
                }
            }

            Button {
                width: main.width*0.5;
                height: Math.min(main.height*0.1, 100*sp);
                anchors { horizontalCenter: parent.horizontalCenter; }
                releasedOpacity: 0.6;
                pressedOpacity: 0.3;
                onClicked: App.changeView("Options");

                Text {
                    text: "Settings";
                    font.pixelSize: parent.height*0.5;
                    anchors { centerIn: parent; }
                    color: contentColor;
                }
            }
        }
    }
}

