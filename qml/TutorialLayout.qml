import QtQuick 2.5
import palette 1.0
import "qrc:/uxo"
import "qrc:/components"
import "qrc:/js/game.js" as GameJS

Column {
    id: main;
    scale: Math.min(parent.height/height, 1);
    width: parent.width - 20*ap;
    spacing: 30*ap;
    anchors { centerIn: parent; }
    property Game game;

    property string title: "Title";
    property string info: "Info";
    property string tutorial: ":/tutorials/start.json"
    property var instructions: ['instruction1', 'instruction2'];
    property int currentInstruction: 0;
    property color color;

    signal finished();
    signal startOver();

    Text {
        text: main.title;
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
        text: main.info;
    }

    Item {
        width: parent.width;
        height: Math.max(tryAgain.height, instructionText.height);
        anchors { horizontalCenter: parent.horizontalCenter; }

        Text {
            id: instructionText;
            font.pixelSize: 25*ap;
            font.weight: Text.Normal;
            anchors { centerIn: parent; }
            opacity: 1 - tryAgain.opacity;
            width: parent.width*0.7;
            horizontalAlignment: Text.AlignHCenter;
            wrapMode: Text.WordWrap;
            text: instructions[Math.min(currentInstruction, instructions.length - 1)];
        }

        Button {
            id: tryAgain;
            enabled: opacity > 0;
            width: 200*ap;
            height: 55*ap;
            opacity: main.currentInstruction >= main.instructions.length;
            color: Qt.lighter(main.color, 1.2);
            pressedColor: Color.setAlpha(color, 0.75);
            anchors { centerIn: parent; }
            onClicked: {
                main.currentInstruction = 0;
                main.startOver();
            }

            Text {
                text: "Try Again";
                font.pixelSize: parent.height*0.35;
                anchors { centerIn: parent; }
            }

            Behavior on opacity { PropertyAnimation { duration: 200; } }
        }
    }

    Rectangle {
        id: container;
        height: width;
        width: Math.min(App.view.width*0.9, App.view.height*0.6);
        color: Palette.gameTheme.background;
        radius: width*0.01;
        anchors { horizontalCenter: parent.horizontalCenter; }
        Component.onCompleted: wait(500, createGame);

        Component {
            id: gameComponent;

            Game {
                tutorial: true;
                gameData: getGame();
                property bool gameOver: false;
                property bool showResults: false;
                anchors { fill: parent; margins: parent.width*0.01; }

                function getGame() {
                    return new GameJS.Game(main.tutorial, 'X', 'O', gameDataChanged, null, null, false);
                }
            }
        }

        function createGame() {
            game = gameComponent.createObject(container);
            finished();
        }
    }
}

