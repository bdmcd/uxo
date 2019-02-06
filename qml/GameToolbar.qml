import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import palette 1.0
import "qrc:/components"

Rectangle {
    id: main;
    state: gameOver ? gameData.board.winner : gameData.turn;
    Behavior on turnColor { PropertyAnimation { duration: 200; } }
    property color turnColor: state == "x" ? Palette.xColor : Palette.oColor;

    RadialGradient {
        anchors { fill: parent; }
        verticalOffset: height*0.5;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Color.setAlpha(turnColor, 0.15); }
            GradientStop { position: 0.8; color: Color.setAlpha(turnColor, 0.0); }
        }
    }

    property var gameData;
    property bool gameOver: gameData.board.winner !== "";

    ColoredImage {
        id: arrow;
        height: 40*dp;
        width: height;
        image.source: "qrc:/img/back.png";
        image.sourceSize: Qt.size(width, height);
        color: Palette.theme.primaryText;
        rotation: 90;
        anchors { top: main.top; topMargin: -10*dp; horizontalCenter: parent.horizontalCenter; }
    }

    RowLayout {
        anchors {
            fill: parent;
            margins: 15*dp;
        }

        Item {
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            X {
                height: parent.height;
                width: height;
                scale: zoomed ? 1 : 0.75;
                opacity: zoomed ? 1 : 0.3
                anchors { centerIn: parent }

                property bool zoomed: main.state === 'x'
                Behavior on scale { PropertyAnimation { duration: 200 } }
                Behavior on opacity { PropertyAnimation { duration: 200 } }
                Component.onCompleted: image.sourceSize = Qt.size(width, height);
            }
        }

        Text {
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            color: Palette.theme.primaryText;
            font.pixelSize: parent.height*0.35
            font.weight: main.gameOver ? Font.Normal : Font.Light;
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter;

            text: {
                if (main.gameOver) {
                    return gameData[gameData.board.winner + "PlayerName"] + " wins!!!"
                }
                return "It's " + gameData[gameData.turn + "PlayerName"] + "'s turn!";
            }
        }

        Item {
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            O {
                height: parent.height;
                width: height;
                scale: zoomed ? 1 : 0.75;
                opacity: zoomed ? 1 : 0.3
                anchors { centerIn: parent }

                property bool zoomed: main.state === 'o'
                Behavior on scale { PropertyAnimation { duration: 200 } }
                Behavior on opacity { PropertyAnimation { duration: 200 } }
                Component.onCompleted: image.sourceSize = Qt.size(width, height);
            }
        }
    }
}


