import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import palette 1.0
import "qrc:/components"

Item {
    id: main;
    enabled: boardEnabled && !board.filled

    property var board;
    property var gameData;
    property double spacing;
    property bool tutorial;
    property var squares: [];
    property bool boardEnabled: board.enabled;
    property bool bigLetterBehind: gameOver && !showResults;

    Item {
        id: winner;
        anchors { fill: parent; }
        layer.enabled: radius !== noRadius;
        layer.effect: MaskedBlur {
            id: blur;
            cached: true;
            samples: winner.radius*0.5;
            maskSource: grid;
            radius: winner.radius;
            fast: winner.fast;
        }

        property bool fast: Settings.value('performance') === "Better Performance";
        property double yesRadius: Math.max(Math.sqrt(width)*(fast ? 100 : 3.5));
        property double noRadius: yesRadius*0.2;
        property double radius: (bigLetterBehind ? noRadius : yesRadius)*0.3;
        Behavior on radius { PropertyAnimation { duration: 150; } }

        Loader {
            anchors { fill: parent; margins: 10*ap; }
            opacity: source == "" ? 0 : 1;
            asynchronous: true;
            Behavior on opacity { PropertyAnimation { duration: 250; } }
            property var binding: {
                if (!sourceComponent || tutorial) {
                    var winner = board.winner.toUpperCase();
                    if (winner === "X" || winner === "O") {
                        setSource("qrc:/components/" + winner + ".qml");
                    }
                    else {
                        setSource("");
                    }
                }
            }
        }
    }

    Rectangle {
        radius: 5;
        color: "transparent"
        visible: !gameOver;
        border.width: spacing/10;
        border.color: board.filled ? "red" : (boardEnabled ? borderColor : Color.setAlpha(borderColor, 0));
        property color borderColor: Palette.gameTheme.border;
        Behavior on border.color { PropertyAnimation { duration: 200; } }

        anchors {
            fill: parent;
            margins: -spacing/3;
        }
    }

    Grid {
        id: grid;
        anchors.fill: parent;
        rows: Math.sqrt(repeater.count);
        columns: rows;
        spacing: width*0.02;

        layer.enabled: gameOver && !showResults;
        layer.effect: FastBlur {
            cached: true;
            radius: grid.layer.enabled ? Math.sqrt(grid.width)*4 : 0;
            Behavior on radius { PropertyAnimation { duration: 300; } }
        }

        Repeater {
            id: repeater;
            model: board.squares.length;

            Square {
                squareIndex: index;
                boardIndex: main.board.index;
                tutorial: main.tutorial;
                state: main.board.squares[index];
                width: grid.width/grid.columns - (2*grid.spacing)/grid.columns;
                height: grid.height/grid.rows - (2*grid.spacing)/grid.rows;
                color: Palette.gameTheme["square" + board.winner.toUpperCase()];
                Behavior on color { PropertyAnimation { duration: 200; } }
                Component.onCompleted: {
                    main.squares[index] = this;
                    main.squaresChanged();
                }
            }
        }
    }

    function squareAt(x, y) {
        var mapped = mapToItem(grid, x, y);
        return grid.childAt(mapped.x, mapped.y);
    }
}
