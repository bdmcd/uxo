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
            title: "What's the catch?"
            tutorial: ":/tutorials/corresponding.json";
            instructions: ["Try it out by playing in the red square", "Now the next player can play anywhere in the corresponding board"];
            info: "<i>You don't get to pick which board you play on. </i>"
                + "Whichever square you play in, your opponent has to play in the corresponding board";

            onStartOver: {
                game.gameData = game.getGame();
                step1();
            }

            onFinished: {
                main.finished();
                game.onBuilt.connect(step1)
                game.onSquareClicked.connect(function(board, square) {
                    switch(currentInstruction) {
                    case 0: step2(square); break;
                    case 1: step3(); break;
                    }
                })
            }

            function step1() {
                var squares = game.board.boards[0].squares
                for (var i = 0; i < 9; squares[i++].tutorialEnabled = false);
                squares[Math.floor(Math.random()*8) + 1].tutorialEnabled = true;
            }
            function step2(index) {
                currentInstruction++;
                for (var i = 0; i < 9; game.board.boards[index].squares[i++].tutorialEnabled = true);
            }
            function step3() {
                currentInstruction++;
                for (var i = 0; i < 9; game.gameData.board.boards[i++].enabled = false);
                game.gameDataChanged();
            }
        }
    }
}
