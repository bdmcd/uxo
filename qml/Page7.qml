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
            title: "What if the board is already won?"
            tutorial: ":/tutorials/alreadyWon.json";
            instructions: ["Try it out by playing in one of the red squares", "Now your opponent can go anywhere on the board"];
            info: "If your opponent sends you into a board that has already been won, then you get to play in any board you want to";

            onStartOver: {
                game.gameData = game.getGame();
                step1();
            }

            onFinished: {
                main.finished();
                game.onBuilt.connect(step1)
                game.onSquareClicked.connect(function(board, square) {
                    switch(currentInstruction) {
                    case 0: step2(); break;
                    case 1: step3(); break;
                    }
                })
            }

            function step1() {
                var s1 = game.board.boards[5].squares[0];
                var s2 = game.board.boards[5].squares[4]
                s1.tutorialEnabled = true; s1.showBorder = true;
                s2.tutorialEnabled = true; s2.showBorder = true;
            }
            function step2() {
                currentInstruction++;
                for (var i = 0; i < 9; i++) {
                    for (var j = 0; j < 9; j++) {
                        var square = game.board.boards[i].squares[j];
                        square.tutorialEnabled = true;
                        square.showBorder = false;
                    }
                }
            }
            function step3() {
                currentInstruction++;
                for (var i = 0; i < 9; game.gameData.board.boards[i++].enabled = false);
                game.gameDataChanged();
            }
        }
    }
}
