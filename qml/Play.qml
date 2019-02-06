import QtQuick 2.5
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import palette 1.0
import "qrc:/js/game.js" as GameJS
import "qrc:/components"

View {
    id: main;
    name: "Play";
    previous: "Home";

    property var selection: [];

    Row {
        id: deleteRow;
        spacing: -15*dp;
        height: parent.height;
        parent: App.toolbar.customRow;
        opacity: selection.length > 0;
        Behavior on opacity { PropertyAnimation { duration: 200; } }

        Button {
            width: height;
            height: parent.height;
            onClicked: deleteDialog.open();

            ColoredImage {
                image.source: "qrc:/img/trash.png";
                image.sourceSize: Qt.size(width, height);
                anchors { fill: parent; margins: parent.height*0.25; }
            }
        }

        Button {
            width: height;
            height: parent.height;
            onClicked: main.selection = [];

            ColoredImage {
                image.source: "qrc:/img/exit.png";
                image.sourceSize: Qt.size(width, height);
                anchors { fill: parent; margins: parent.height*0.3; }
            }
        }
    }

    Column {
        spacing: 20*dp;
        anchors { fill: parent; margins: 20*dp }

        Rectangle {
            id: background;
            radius: 20*dp;
            clip: true;
            color: Color.setAlpha("black", 0.07);
            width: parent.width;
            height: parent.height - createButton.height - parent.spacing;

            ListView {
                id: list;
                model: folderModel
                delegate: fileDelegate
                anchors {
                    fill: parent;
                    margins: 20*dp;
                }
                property Button noSavedGamesButton;

                onCountChanged: {
                    if (count == 0) {
                        var properties ={
                            gameString: "{}",
                            path: "",
                            title: "No Saved Games",
                            info: "New Game",
                            click: function() {
                                App.changeView("NewGame", { previous: main.name });
                            }
                        }
                        noSavedGamesButton = fileDelegate.createObject(list, properties)
                    }
                    else if (!!noSavedGamesButton) {
                        noSavedGamesButton.destroy();
                    }
                }
            }
        }

        Row {
            height: 40*dp;
            spacing: 15*dp;
            anchors { horizontalCenter: parent.horizontalCenter; }

            Button {
                id: createButton;
                height: parent.height;
                width: 175*dp;
                color: Qt.darker(main.color, 1.2);
                pressedColor: Color.addAlpha(color, 0.3);
                pressedOpacity: releasedOpacity;
                anchors { verticalCenter: parent.verticalCenter; }
                onClicked: App.changeView("NewGame", { previous: main.name })

                Text {
                    text: "New Game";
                    font.pixelSize: parent.height*0.4;
                    anchors { centerIn: parent; }
                }
            }
        }
    }


    FolderListModel {
        id: folderModel
        folder: "file://" + FileIO.gameDirectory();
        sortField: FolderListModel.Time;
        Component.onCompleted: nameFilters = ['*[0-9]*']
    }

    Component {
        id: fileDelegate
        Button {
            id: root;
            height: 50*dp;
            width: parent.width;
            color: Color.setAlpha(main.color, 0);
            pressedColor: Color.setAlpha(color, 0.75);
            pressedOpacity: releasedOpacity;
            selected: main.selection.indexOf(path) >= 0;

            property string path: "games/" + fileName;
            property string gameString: FileIO.read(path)
            property string title: gameData.xPlayerName + " vs " + gameData.oPlayerName;
            property string info: gameData[gameData.turn + "PlayerName"] + "'s turn";
            property var gameData: JSON.parse(gameString);
            property bool selectable: path.indexOf("games") >= 0;

            onClicked: {
                if (main.selection.length > 0) toggle();
                else click();
            }
            onPressAndHold: {
                select();
            }

            property var click: function() {
                App.changeView("UXO", { gameName: gameData.name });
            }

            Text {
                font.pixelSize: parent.height*0.4;
                text: root.title;
                width: parent.width - rightRow.width;
                elide: Text.ElideRight;
                anchors {
                    left: parent.left;
                    leftMargin: (parent.height - height)*0.5;
                    verticalCenter: parent.verticalCenter;
                }
                font.weight: Font.Normal;
            }

            Row {
                id: rightRow;
                spacing: 10*dp;
                height: parent.height;
                anchors { right: parent.right; }

                Text {
                    font.pixelSize: parent.height*0.3
                    anchors { verticalCenter: parent.verticalCenter; }
                    text: root.info;
                }

                ColoredImage {
                    width: height;
                    height: parent.height*0.5;
                    image.source: "qrc:/img/forward.png";
                    anchors { verticalCenter: parent.verticalCenter; }
                }
            }

            function select() {
                if (!selected) {
                    selection.push(path);
                    selectionChanged();
                }
            }

            function deselect() {
                if (selected) {
                    selection.splice(selection.indexOf(path), 1);
                    selectionChanged();
                }
            }

            function toggle() {
                if (selected) deselect();
                else select();
            }
        }
    }

    MessageDialog {
        id: deleteDialog;
        text: "Delete selected games?";
        standardButtons: StandardButton.Yes | StandardButton.No;
        onYes: {
            for (var i = 0; i < selection.length; FileIO.remove(selection[i++]));
            selection = [];
        }
    }
}
