import QtQuick 2.5
import QtQuick.Controls 2.2

Item {
    id: main;

    property var gameData;
    property bool tutorial: false;
    property alias board: outerBoard;
    signal squareClicked(var boardIndex, var squareIndex);
    signal zoom(var center, var item);
    signal built();   

    OuterBoard {
        id: outerBoard;
        gameData: main.gameData;
        board: main.gameData.board;
        anchors { fill: parent; margins: 20*dp; }
        onBuilt: main.built();
        tutorial: main.tutorial;
//        showResults: main.showResults;
    }

    MouseArea {
        anchors { fill: parent; }
        property bool clickAccepted;
        onPressed: clickAccepted = false;
        onDoubleClicked: zoom(mouse);
        onClicked: {
            clickAccepted = true;
            var x = mouse.x, y = mouse.y;
            wait(150, function() { selectSquare(x, y) });
        }

        function zoom(mouse) {
            main.zoom(mouse, main);
            clickAccepted = false;
        }
        function selectSquare(x, y) {
            if (clickAccepted) {
                var square = main.squareAt(x, y);
                if (square && square.enabled) {
                    gameData.squareSelected(square.boardIndex, square.squareIndex);
                    main.squareClicked(square.boardIndex, square.squareIndex);
                }
            }
        }
    }

    function squareAt(x, y) {
        var mapped = mapToItem(outerBoard, x, y);
        return outerBoard.squareAt(mapped.x, mapped.y);
    }
}

