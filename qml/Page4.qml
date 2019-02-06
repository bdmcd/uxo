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
            title: "Winning a Board"
            tutorial: ":/tutorials/winBoard.json";
            instructions: ["Try it out by playing in the red square"];
            info: "When you get three in a row on one of the inner boards, you win that board.";

            onStartOver: {
                game.gameData = game.getGame();
                start();
            }

            onFinished: {
                main.finished();
                game.onBuilt.connect(start)
                game.onSquareClicked.connect(squareClicked)
            }

            function start() {
                game.board.boards[8].squares[1].tutorialEnabled = true;
            }

            function squareClicked() {
                currentInstruction++;
                for (var i = 0; i < 9; game.gameData.board.boards[i++].enabled = false);
                game.gameDataChanged();
            }
        }
    }
}

