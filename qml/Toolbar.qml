import QtQuick 2.5
import QtQuick.Layouts 1.1
import palette 1.0
import "qrc:/components"

Rectangle {
    id: main;
    visible: App.view.showToolbar;
    height: App.view.showToolbar ? 60*dp : 0;
    color: App.view.toolbarColor;
    anchors {
        left: parent.left;
        right: parent.right;
        top: parent.top;
    }

    property alias titleRow: titleRow;
    property alias copyRow: copyRow;
    property alias customRow: customRow;

    Button {
        id: backButton;
        height: parent.height;
        width: backRow.width + 10*dp;
        anchors { left: parent.left; }
        color: 'transparent';
        pressedColor: color;
        onClicked: App.keyHandler.keyPressed({ key: Qt.Key_Back })

        Row {
            id: backRow;
            height: parent.height;
            opacity: parent.containsPress ? 0.5 : 1;

            ColoredImage {
                image.source: "qrc:/img/back.png";
                height: parent.height*0.6;
                width: height;
                anchors { verticalCenter: parent.verticalCenter; }
                color: App.view.toolbarForegroundColor;
            }

            LogoText {
                font.pixelSize: parent.height*0.4;
                anchors { verticalCenter: parent.verticalCenter; }
                color: App.view.toolbarForegroundColor;
            }
        }
    }

    Row {
        id: titleRow;
        height: parent.height;
        anchors { left: backButton.right; margins: 15*dp; }

        Text {
            anchors { verticalCenter: parent.verticalCenter; }
            color: App.view.title.color;
            text: App.view.title.text;
            font: App.view.title.font;
        }
    }

    Row {
        id: copyRow;
        height: parent.height;
        opacity: copyText && copyText.focus ? 1 : 0;
        visible: opacity;
        enabled: visible;
        spacing: -10*dp;
        anchors { right: settingsButton.left }
        Behavior on opacity { PropertyAnimation { duration: 200; } }
        property TextBox copyText;

        Button {
            height: parent.height;
            width: height;
            onClicked: copyRow.copyText.copy();
            ColoredImage {
                image.source: "qrc:/img/copy.png";
                color: App.view.toolbarForegroundColor;
                anchors { fill: parent; margins: parent.height*0.3 }
            }
        }
        Button {
            height: parent.height;
            width: height;
            onClicked: copyRow.copyText.cut();
            ColoredImage {
                image.source: "qrc:/img/cut.png";
                color: App.view.toolbarForegroundColor;
                anchors { fill: parent; margins: parent.height*0.3 }
            }
        }
        Button {
            height: parent.height;
            width: height;
            onClicked: copyRow.copyText.paste();
            ColoredImage {
                image.source: "qrc:/img/paste.png";
                color: App.view.toolbarForegroundColor;
                anchors { fill: parent; margins: parent.height*0.3 }
            }
        }
    }

    Row {
        id: customRow;
        spacing: -10*ap;
        height: parent.height;
        anchors { right: settingsButton.left; }
    }


    SettingsButton {
        id: settingsButton;
        height: parent.height;
        width: height*0.8;
        anchors { right: parent.right }
        visible: App.view.dropdownModel.length > 0;
        enabled: visible;
        onClicked: App.dropdown.toggle();
    }
}

