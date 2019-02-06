import QtQuick 2.5
import QtQml.Models 2.2
import palette 1.0

Item {
    id: main;
    anchors { fill: parent; topMargin: App.toolbar.height; }

    property color color: Palette.theme.background;
    property color toolbarColor: Qt.darker(color, 1.2);
    property color toolbarForegroundColor: Palette.theme.primaryText;
    property Item theme: Palette.menuTheme;
    property bool showToolbar: true;
    property string name: "";
    property string previous: "";
    property var previousData;
    property alias title: title;

    Text {
        id: title;
        font.pixelSize: App.toolbar.height*0.35;
        color: toolbarForegroundColor;
        visible: false;
    }

    property var dropdownModel: [
        { name: "Settings", onClick: function() { App.changeView("Options", { previous: name }) } }
    ]

    function onKeyPressed(event) {
        if (event.backButton) {
            event.accepted = true;
            goBack();
        }
    }

    function goBack() {
        if (previous === "") {
            Qt.quit();
        }
        else {
            App.changeView(previous, previousData);
        }
    }
}

