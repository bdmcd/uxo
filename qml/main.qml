import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: main;
    width: 600;
    height: 800;
    visible: true

    Component.onCompleted: {
        screenSize = Qt.binding(function() {
            return {
                width: main.width,
                height: main.height,
                pixelDensity: Screen.pixelDensity
            }
        });

        appComponent.createObject(contentItem);
    }

    Item {
        id: keys;
        focus: true;
        Keys.onPressed: keyPressed(event);

        function keyPressed(event) {
            event.backButton = event.key === Qt.Key_Back || event.key === Qt.Key_Escape;
            function recurse(item) {
                if (!event.accepted && item) {
                    for (var i = item.children.length - 1; i >= 0; recurse(item.children[i--]));
                    if (!event.accepted && typeof item.onKeyPressed == 'function') {
                        item.onKeyPressed(event);
                    }
                }
            }
            recurse(App);
        }
    }

    Component {
        id: appComponent;
        Program {
            readonly property var init: {
                App = this;
                keyHandler = keys;
            }
        }
    }
}

