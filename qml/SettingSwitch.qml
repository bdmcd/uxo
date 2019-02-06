import QtQuick 2.5
import palette 1.0;
import "qrc:/components"

Row {
    id: main;
    spacing: 40*sp;

    property var options: [];
    property string settingKey;
    property string settingName: settingNameText.text;
    property var setting;

    Component.onCompleted: setting = Settings.value(settingKey, options[0]);
    onSettingChanged: Settings.setValue(settingKey, setting)

    Text {
        id: settingNameText;
        width: 150*sp;
        font.pixelSize: width*0.2;
        font.weight: Font.Normal;
        text: main.settingName + ":"
        horizontalAlignment: Text.AlignRight;
        anchors { verticalCenter: parent.verticalCenter; }
    }

    Row {
        spacing: 10*sp;
        anchors { verticalCenter: parent.verticalCenter; }
        Repeater {
            model: options;

            Rectangle {
                width: 130*sp;
                height: width*0.45;
                radius: height*0.1;
                color: Color.setAlpha("black", selected ? 0.25 : 0)
                anchors { verticalCenter: parent.verticalCenter; }
                Behavior on color { PropertyAnimation { duration: 100; } }

                property bool selected: main.setting == modelData;

                Text {
                    text: modelData;
                    width: parent.width*0.9;
                    wrapMode: Text.WordWrap;
                    horizontalAlignment: Text.AlignHCenter
                    anchors { centerIn: parent; }
                    font.weight: selected ? Font.Normal : Font.Light;
                    font.pixelSize: 20*sp;
                }

                MouseArea {
                    anchors { fill: parent; }
                    onClicked: {
                        main.setting = modelData
                    }
                }
            }
        }
    }
}

