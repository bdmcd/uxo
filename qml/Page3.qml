import QtQuick 2.5

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

        TutorialLayout {
            color: main.color;
            title: "How to Play"
            tutorial: ":/tutorials/start.json";
            instructions: ["Try it out by playing in any square"];
            info: "Each turn, you play in one of the small squares.\nThe green border marks boards that you are allowed to play in."

            onStartOver: {
                game.gameData = game.getGame();
                runTutorial();
            }

            onFinished: {
                main.finished();
                game.onBuilt.connect(runTutorial)
                game.onSquareClicked.connect(squareClicked)
            }

            function runTutorial() {
                for (var i = 0; i < 9; i++) {
                    game.gameData.board.boards[i].enabled = true;
                    for (var j = 0; j < 9; j++) {
                        var square = game.board.boards[i].squares[j];
                        square.tutorialEnabled = true;
                        square.showBorder = false;
                    }
                }
                game.gameDataChanged();
            }

            function squareClicked() {
                currentInstruction++;
                for (var i = 0; i < 9; i++) {
                    game.gameData.board.boards[i].enabled = false;
                }
                game.gameDataChanged();
            }
        }
    }
}

