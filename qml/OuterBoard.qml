import QtQuick 2.5
import palette 1.0

Grid {
    id: main;
    rows: Math.sqrt(repeater.count);
    columns: rows;
    spacing: width*0.03;
    enabled: board.enabled;

    property var board;
    property var gameData;
    property bool tutorial;
    property double boardSize: width/columns - (2*spacing)/columns;
    property var boards: [];
    property int boardCount: 0;

    signal built();

    Repeater {
        id: repeater;
        model: board.boards.length;

        InnerBoard {
            width: main.boardSize;
            height: main.boardSize;
            gameData: main.gameData;
            board: main.board.boards[index];
            spacing: main.spacing;
            tutorial: main.tutorial;
//            showResults: main.showResults;
            property int col: index % 3;
            property int row: Math.floor(index/3);
            property point center: {
                var binding = repeater.items | width | height | index;
                var offset = main.mapToItem(main.parent, 0, 0)
                return Qt.point(offset.x + col*(width + spacing) + width/2, offset.y + row*(height + spacing) + height/2)
            }

            Component.onCompleted: {
                main.boards[index] = this;
                main.boardsChanged();
                main.boardCount++;
                if (main.boardCount === repeater.model) {
                    wait(10, built);
                }
            }
        }
    }

    Rectangle {
        id: winLine;
        parent: main.parent;
        color: Color.invert(Palette.gameTheme.background)
        radius: height;
        height: 10*ap;
        width: pos.length;
        rotation: pos.angle;
        x: pos.x;
        y: pos.y;
        opacity: !showResults * 0.65;
        transformOrigin: Item.Left;
        property var pos: getPos();

        Behavior on width { PropertyAnimation { duration: 600; easing.type: Easing.OutQuint } }
        Behavior on opacity { PropertyAnimation { duration: 150; } }

        function getPos() {
            var winCombo = gameData.winCombo;
            if (gameOver && winCombo && main.boardCount == 9) {
                var point1 = main.boards[winCombo[0]].center;
                var point2 = main.boards[winCombo[winCombo.length - 1]].center;
                var a = point2.x - point1.x
                var b = point2.y - point1.y;

                return {
                    x: point1.x,
                    y: point1.y,
                    length: Math.sqrt(a*a + b*b),
                    angle: Math.atan2(b, a)*180 / Math.PI
                }
            }
            return { x: -99999, y: -99999, length: 0, angle: 0 };
        }
    }


    function squareAt(x, y) {
        var child = childAt(x, y);
        if (child && child.squareAt) {
            var mapped = mapToItem(child, x, y);
            return child.squareAt(mapped.x, mapped.y);
        }
        return null;
    }
}
