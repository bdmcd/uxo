import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import palette 1.0
import "qrc:/uxo"
import "qrc:/components"
import "qrc:/js/game.js" as GameJS

View {
    id: main;
    name: "UXO";
    previous: "Home";
    theme: Palette.gameTheme;
    title.text: gameData.xPlayerName + " vs " + gameData.oPlayerName;
    property string xPlayerName;
    property string oPlayerName;
    property string gameName;
    property bool showResults: false;
    property bool gameOver;
    property var gameData: new GameJS.Game(gameName, xPlayerName, oPlayerName, gameDataChanged, gameOver, catsGame);
    property var backObject: ({ previous: name, previousData: { gameName: gameData.name } })

    onGameDataChanged: {
        if (gameData && gameData.board.winner !== "") {
            wait(200, function() { gameOver = gameData.board.winner !== ''; })
        }
        else gameOver = false;
    }

    dropdownModel: [
        { name: "Settings", onClick: function() { App.changeView("Options", backObject) } },
        { name: "Help", onClick: function() { App.changeView("Help", backObject) } }
    ]

    Column {
        enabled: stats.hidden;
        anchors { fill: parent; }

        ScaleArea {
            id: scaleArea;
            width: parent.width;
            height: parent.height - toolbar.height - buttonContainer.height;
            target: gameContainer;

            Item {
                id: gameContainer;
                width: scaleArea.width;
                height: scaleArea.height;

                Game {
                    id: game;
                    gameData: main.gameData;
                    anchors { centerIn: parent; }
                    width: Math.min(parent.width, parent.height) - margins;
                    height: width;
                    onZoom: scaleArea.zoom(center, item);

                    property double margins: 10*dp;
                }
            }
        }

        Item {
            id: buttonContainer;
            height: 70*dp * visible;
            width: 150*dp;
            visible: gameOver;
            anchors { horizontalCenter: parent.horizontalCenter; }
            Behavior on height { PropertyAnimation { duration: 150; } }

            Button {
                id: showResultsButton;
                color: Palette.theme.secondaryBackground;
                anchors { fill: parent; bottomMargin: 20*dp; }
                onClicked: showResults = !showResults;

                Text {
                    text: showResults ? "Hide Board" : "Show Board";
                    anchors.centerIn: parent;
                    font.pixelSize: parent.height*0.4;
                }
            }
        }

        GameToolbar {
            id: toolbar;
            gameData: game.gameData;
            width: parent.width;
            height: 80*dp;
            color: Color.setAlpha(main.color, 0.95)
        }

        layer.enabled: !stats.hidden;
        layer.effect: MaskedBlur {
            maskSource: stats;
            radius: Math.sqrt(width)*1000;
            fast: true;
        }
    }

    Rectangle {
        id: shade;
        opacity: 0.35
        width: parent.width;
        height: parent.height;
        y: stats.contentY;
        color: Qt.darker(stats.color, 1.25);
        visible: Palette.gameThemeName === "Light"
    }

    Stats {
        id: stats;
        gameData: game.gameData;
        anchors { fill: parent; }
    }

    Component.onCompleted: {
        var tutorialKey = "showTutorial"
        if (Settings.value(tutorialKey, true) === "true") {
            App.changeView("Help", backObject);
            Settings.setValue(tutorialKey, false);
        }
    }

    function gameOver() {
        wait(2000, stats.show)
    }

    function catsGame() {
        wait(500, stats.show);
    }
}

