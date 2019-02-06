pragma Singleton
import QtQuick 2.5

Item {
    id: main;   
    property string gameThemeName: Settings.value('gameTheme');
    property string menuThemeName: Settings.value('menuTheme');
    property Item gameTheme: gameThemeName == "Light" ? lightTheme : darkTheme;
    property Item menuTheme: menuThemeName == "Blue" ? blueTheme : redTheme;
    property Item theme: App.view.theme;

    property color xColor: "#2196f3";
    property color oColor: "#ff5651" //"#e42410";
    property color lightText: "#ddd";
    property color darkText: "#333";

    Item {
        id: lightTheme;
        property color background: "#eee";
        property color secondaryBackground: Qt.darker(background, 1.1);
        property color primaryText: main.darkText;
        property color secondaryText: main.lightText;
        property color square: Color.addAlpha(Qt.darker(background, 1.3), 0.5);
        property color squareX: Color.setAlpha(Color.average(xColor, gameTheme.background), 0.45);
        property color squareO: Color.setAlpha(Color.average(oColor, gameTheme.background), 0.45);
        property color border: "#388E3C";
    }

    Item {
        id: darkTheme;
        property color background: "#333";
        property color secondaryBackground: Qt.lighter(background, 1.1);
        property color primaryText: main.lightText;
        property color secondaryText: main.darkText;
        property color square: Color.addAlpha(Qt.lighter(background, 1.4), 0.5);
        property color squareX: Color.setAlpha(Color.average(xColor, gameTheme.background), 0.45);
        property color squareO: Color.setAlpha(Color.average(oColor, gameTheme.background), 0.45);
        property color border: "#66BB6A";
    }

    Item {
        id: redTheme;
        property color background: Qt.darker(main.oColor, 1.1);
        property color secondaryBackground: Qt.darker(background, 1.1);
        property color primaryText: main.lightText;
        property color secondaryText: main.darkText
        property color square: Color.addAlpha(Qt.lighter(background, 1.4), 0.5);
        property color squareX: Color.setAlpha(Color.average(xColor, theme.background), 0.45);
        property color squareO: Color.setAlpha(Color.average(oColor, theme.background), 0.45);
        property color border: "#388E3C";
    }

    Item {
        id: blueTheme;
        property color background: main.xColor;
        property color secondaryBackground: Qt.darker(background, 1.1);
        property color primaryText: main.lightText;
        property color secondaryText: main.darkText;
        property color square: Color.addAlpha("black", 0.5);
        property color squareX: Color.setAlpha(Color.average(xColor, square), 0.45);
        property color squareO: Color.setAlpha(Color.average(oColor, square), 0.45);
        property color border: "#4caf50";
    }
}

