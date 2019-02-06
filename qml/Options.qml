import QtQuick 2.5
import palette 1.0
import "qrc:/components"

View {
    id: main;
    name: "Options";
    previous: "Home";
    dropdownModel: [];

    Column {
        spacing: 40*dp;
        anchors {
            top: parent.top;
            topMargin: Math.min(parent.width - width, parent.height - height)*0.45;
            horizontalCenter: parent.horizontalCenter;
        }

        SettingSwitch {
            settingKey: 'menuTheme'
            settingName: "Menu Theme";
            options: ["Red", "Blue"];
            onSettingChanged: Palette.menuThemeName = setting;
        }

        SettingSwitch {
            settingKey: 'gameTheme'
            settingName: "Game Theme";
            options: ["Dark", "Light"];
            onSettingChanged: Palette.gameThemeName = setting;
        }

        SettingSwitch {
            settingKey: 'performance';
            settingName: "Performance";
            options: ["Better Performance", "Better Graphics"];
        }
    }
}

