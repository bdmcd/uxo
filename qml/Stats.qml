import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import palette 1.0
import "qrc:/components"

Item {
    id: main;
    state: gameOver ? gameData.board.winner : gameData.turn;

    property var gameData;
    property bool gameOver: gameData.board.catsGame || gameData.board.winner !== "";
    property color color: gameData.board.catsGame ? "#444" : Palette[state + "Color"];
    property bool hidden: mouse.y === mouse.drag.maximumY;
    property double contentY: mouse.y + mouse.margin;

    MouseArea {
        id: mouse;
        width: parent.width;
        height: parent.height + margin;
        y: parent.height - margin;
        property double margin: 80*ap;
        property double oldY: y;
        property double dy: 0;
        property PropertyAnimation anim: PropertyAnimation {
            target: mouse;
            property: 'y';
            duration: 600;
            easing.type: Easing.OutQuint;
            onStopped: mouse.y = Qt.binding(function() { return to; })
        }

        drag {
            target: mouse;
            axis: Drag.YAxis;
            maximumY: main.height - margin;
            minimumY: bar.height - margin;
        }

        Rectangle {
            id: bar;
            height: 3*ap;
            width: parent.width;
            color: main.color;
            anchors { bottom: container.top; }
        }

        Rectangle {
            id: container;
            anchors { fill: parent; topMargin: parent.margin; }
            color: {
                var color = main.color;
                if (Palette.gameThemeName == "Light") {
                    color = Qt.darker(main.color, 2);
                }
                return Color.setAlpha(color, 0.25);
            }

            Column {
                spacing: 30*ap
                anchors { fill: parent; margins: spacing; }

                Text {
                    id: turnText;
                    font.pixelSize: 35*dp;
                    font.weight: Font.Normal;
                    color: Palette.lightText;
                    anchors { horizontalCenter: parent.horizontalCenter; }
                    text: {
                        if (gameData.board.catsGame) {
                            return "Cat's Game";
                        }
                        if (gameOver) {
                            return gameData[gameData.board.winner + "PlayerName"] + " wins!";
                        }
                        return gameData[gameData.turn + "PlayerName"] + "'s turn";
                    }
                }

                Rectangle {
                    id: innerContainer;
                    color: Color.setAlpha(main.color, 0.1);
                    radius: 10*ap;
                    width: parent.width;
                    height: parent.height - continueButton.height - turnText.height - parent.spacing*2;
                    property color baseColor: Qt.darker(main.color, Palette.gameThemeName === "Light" ? 2.7 : 0.8);

                    Column {
                        spacing: 15*ap;
                        anchors { fill: parent; topMargin: 20*dp }

                        Text {
                            id: statsText;
                            text: "Statistics";
                            font.pixelSize: 25*ap;
                            color: Palette.lightText;
                            anchors { horizontalCenter: parent.horizontalCenter; }
                        }

                        Rectangle {
                            height: 1;
                            width: parent.width - 140*sp;
                            color: Color.setAlpha("white", 0.4);
                            anchors { horizontalCenter: parent.horizontalCenter; }
                        }

                        TableView {
                            enabled: false;
                            model: ListModel{ id: tableModel; dynamicRoles: true; }
                            alternatingRowColors: false;
                            backgroundVisible: false;
                            frameVisible: false;
                            selectionMode: SelectionMode.NoSelection;
                            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff;
                            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff;
                            width: parent.width;
                            height: parent.height;
                            style: TableViewStyle {
                                backgroundColor: "transparent";
                                alternateBackgroundColor: "transparent"
                            }
                            headerDelegate: Text {
                                text: styleData.value;
                                font.weight: Font.Normal;
                                font.pixelSize: 30*ap;
                                horizontalAlignment: Text.AlignHCenter;
                                verticalAlignment: Text.AlignVCenter;
                                color: Palette.lightText;
                                elide: Text.ElideRight;
                                height: 70*ap;
                            }
                            rowDelegate: Item {
                                height: 50*ap;
                            }
                            itemDelegate: Text {
                                text: styleData.value;
                                font.pixelSize: 25*ap;
                                font.weight: header ? Font.Normal : Font.Light;
                                horizontalAlignment: header ? Text.AlignRight : Text.AlignHCenter;
                                verticalAlignment: Text.AlignVCenter
                                color: Palette.lightText;

                                property bool header: styleData.column === 0
                            }

                            TableViewColumn { role: "name"; title: ""; width: parent.width/3.5 }
                            TableViewColumn { role: "x"; title: gameData.xPlayerName; width: parent.width/6 }
                            TableViewColumn { role: "o"; title: gameData.oPlayerName; width: parent.width/6}
                            TableViewColumn { role: "total"; title: "Total"; width: parent.width/6 }

                            property var array: {
                                tableModel.clear();
                                var xStats = gameData.stats('x');
                                var oStats = gameData.stats('o');
                                for (var key in xStats) {
                                    var x = xStats[key].value;
                                    var o = oStats[key].value;
                                    var total = x + o;
                                    if (key === "averageTime") {
                                        total = hms((x + o)/2);
                                        x = hms(x);
                                        o = hms(o);
                                    }
                                    tableModel.append({ name: xStats[key].name, x: x, o: o, total: total });
                                }
                                //move average time to the bottom
                                wait(0, function() { tableModel.move(0, tableModel.count - 1, 1) });
                            }

                            function hms(ms) {
                                var hours = Math.floor(ms/(1000*60*60));
                                var mins = Math.floor(ms/(1000*60)) - hours*60;
                                var secs = Math.floor(ms/(1000)) - mins*60;
                                var str = "";

                                if (hours > 0) return hours + "h " + mins + "m";
                                if (mins > 0) return mins + "m " + secs + "s";
                                return secs + "s"
                            }
                        }
                    }
                }

                Button {
                    id: continueButton;
                    width: 200*ap;
                    height: 60*ap;
                    opacity: 1;
                    color: innerContainer.color;
                    pressedColor: Color.setAlpha(color, 0.05);
                    anchors { horizontalCenter: parent.horizontalCenter }
                    onClicked: {
                        if (main.gameOver) {
                            FileIO.remove(gameData.fileName());
                            App.view.goBack();
                        }
                        else {
                            hide();
                        }
                    }

                    Text {
                        text: main.gameOver ? "Exit Game" : "Back to Game";
                        font.pixelSize: parent.height*0.35;
                        color: Palette.lightText;
                        anchors { centerIn: parent; }
                    }
                }
            }
        }

        onClicked: {
            if (hidden)
                show();
        }
        onReleased: {
            if (dy < 0)
                show();
            else
                hide();
        }

        onYChanged: {
            dy = y - oldY;
            oldY = y;
        }

        function show() {
            anim.stop();
            y = y;
            anim.to = Qt.binding(function() { return drag.minimumY });
            anim.start();
        }

        function hide() {
            anim.stop();
            y = y;
            anim.to = Qt.binding(function() { return drag.maximumY });
            anim.start();
        }
    }

    function show() {
        mouse.show();
    }

    function hide() {
        mouse.hide();
    }

    function toggle() {
        if (main.hidden)
            main.show();
        else
            main.hide();
    }

    function onKeyPressed(event) {
        if (!hidden && event.back) {
            hide();
            event.accepted = true;
        }
    }
}

