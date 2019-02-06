import QtQuick 2.5
import palette 1.0
import "qrc:/components"

View {
    id: main;
    name: "NewGame"
    previous: "Play";

    Column {
        id: column;
        spacing: 40*ap;
        anchors {
            top: parent.top;
            topMargin: Math.max(Math.min((parent.width - width), (parent.height - height)*0.4), 20*ap);
            horizontalCenter: parent.horizontalCenter;
        }

        Column {
            spacing: 20*ap;
            width: parent.width;

            TextBox {
                id: xPlayerName;
                width: 500*ap;
                height: 60*ap;
                placeholderText: "Player 1"
                anchors { horizontalCenter: parent.horizontalCenter }
            }
            TextBox {
                id: oPlayerName;
                width: xPlayerName.width;
                height: xPlayerName.height;
                placeholderText: "Player 2"
                nextOnEnter: false;
                onEnterPressed: startGame();
                anchors { horizontalCenter: parent.horizontalCenter }
            }
        }

        Button {
            width: 200*ap;
            height: 70*ap;
            anchors { horizontalCenter: parent.horizontalCenter }
            color: Color.setAlpha("black", 0.15)
            radius: height*0.1;
            onClicked: startGame();

            Text {
                anchors.centerIn: parent;
                text: "Start";
                font.pixelSize: parent.height*0.4;
            }
        }

        Item { width: 1; height: 1; } //spacing

        Row {
            spacing: 8*ap;
            anchors { horizontalCenter: parent.horizontalCenter; }
            property size line: Qt.size(200*ap, 2*ap);

            Rectangle {
                color: Palette.theme.primaryText;
                width: parent.line.width;
                height: parent.line.height;
                anchors { verticalCenter: parent.verticalCenter }
            }
            Text {
                text: "OR";
                font.pixelSize: 22*ap;
                font.weight: Font.Normal;
                anchors { verticalCenter: parent.verticalCenter }
            }
            Rectangle {
                color: Palette.theme.primaryText;
                width: parent.line.width;
                height: parent.line.height;
                anchors { verticalCenter: parent.verticalCenter }
            }
        }

        Button {
            width: 200*ap
            height: 50*ap;
            color: Color.setAlpha("black", 0.1);
            anchors { horizontalCenter: parent.horizontalCenter; }
            onClicked: App.changeView("Play", { previous: "NewGame" });

            Text {
                text: "Load Game";
                anchors { centerIn: parent; }
                font.pixelSize: parent.height*0.4;
            }
        }
    }

    function startGame() {
        App.keyHandler.forceActiveFocus();
        if (xPlayerName.text.split(' ').join('') == '') {
            xPlayerName.text = "X";
        }
        if (oPlayerName.text.split(' ').join('') == '') {
            oPlayerName.text = "O"
        }
        do {
            var gameName = Math.floor(Math.random()*999999);
        } while(FileIO.exists("games/" + gameName + ".json"));
        App.changeView('UXO', { gameName: gameName, xPlayerName: xPlayerName.text, oPlayerName: oPlayerName.text })
    }
}

