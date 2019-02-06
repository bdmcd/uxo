import QtQuick 2.5
import palette 1.0
import "qrc:/components"

MouseArea {
    id: main;
    enabled: showing;
    visible: progress != 0;
    onClicked: hide();
    anchors {
        fill: parent;
        topMargin: App.toolbar.height;
    }

    property bool showing: false;
    property double progress: showing ? 1 : 0;
    Behavior on progress {
        id: behavior
        PropertyAnimation {
            easing.type: main.showing ? Easing.InQuint : Easing.OutQuint;
            duration: 200;
        }
    }

    Column {
        id: menu;
        anchors {
            right: parent.right;
            top: parent.top;
        }

        transform: Scale {
            yScale: main.progress;
        }

        Repeater {
            model: App.view.dropdownModel;

            Button {
                color: App.toolbar.color;
                pressedOpacity: 0.8;
                width: 200*dp;
                height: 45*dp;
                radius: 0;
                property var model: App.view.dropdownModel[index];

                onClicked: {
                    model.onClick();
                    main.hide()
                }

                Text {
                    font.pixelSize: parent.height*0.4;
                    text: model.name;
                    color: Color.hsla(parent.color).l > 0.7 ? Palette.darkText : Palette.lightText;
                    anchors {
                        left: parent.left;
                        leftMargin: (parent.height - height)
                        verticalCenter: parent.verticalCenter;
                    }
                }
            }
        }
    }

    function show(animate) {
        if (typeof animate == 'undefined')
            animate = true;

        behavior.enabled = animate;
        showing = true;
        behavior.enabled = true;
    }

    function hide(animate) {
        if (typeof animate == 'undefined')
            animate = true;

        behavior.enabled = animate;
        showing = false;
        behavior.enabled = true;
    }

    function toggle(animate) {
        if (typeof animate == 'undefined')
            animate = true;

        behavior.enabled = animate;
        showing = !showing;
        behavior.enabled = true;
    }
}

