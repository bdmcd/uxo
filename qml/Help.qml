import QtQuick 2.5
import palette 1.0
import "qrc:/tutorial"
import "qrc:/components"

View {
    id: main;
    name: "Help";
    previous: "Home";
    toolbarColor: "transparent";
    anchors.topMargin: 0;
    dropdownModel: [];

    Flickable {
        id: flickable;
        anchors { fill: parent; }
        enabled: !snapAnim.running;
        contentHeight: height;
        contentWidth: pageRow.width;
        flickDeceleration: 999999999;
        boundsBehavior: Flickable.StopAtBounds;
        interactive: pageRow.ready;
        property double dx;

        Row {
            id: pageRow;
            height: parent.height;
            property int position: 0;
            property int count: width/main.width;
            property int finishedCount: 0;
            property bool ready: finishedCount >= count;

            Page1 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.0)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
                ready: pageRow.ready;
            }
            Page2 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.1)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page3 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.2)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page4 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.3)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page5 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.4)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page6 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.3)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page7 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.2)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page8 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.1)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
            Page9 {
                width: main.width;
                height: main.height;
                color: Qt.darker(main.color, 1.0)
                onPage: isOnPage(x);
                onFinished: pageRow.finishedCount++;
            }
        }

        onFlickEnded: snap(isMobile ? -dx : dx);
        onHorizontalVelocityChanged: {
            if (horizontalVelocity != 0) {
                dx = horizontalVelocity
            }
        }

        function onKeyPressed(event) {
            if (pageRow.ready) {
                if (event.key === Qt.Key_Right) {
                    snap(-1);
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Left) {
                    snap(1);
                    event.accepted = true;
                }
            }
        }

        function snap(velocity) {
            snapAnim.stop();
            var next = velocity < 0;
            var target = contentX/main.width + (next ? 0.1 : -0.1);
            target = velocity > 0 ? Math.floor(target) : Math.ceil(target);
            target = Math.min(Math.max(target, 0), pageRow.count - 1);

            contentX = contentX; //release binding
            pageRow.position = target;
            snapAnim.start();
        }

        PropertyAnimation {
            id: snapAnim;
            target: flickable;
            to: pageRow.position*main.width;
            property: 'contentX';
            duration: 500;
            easing.type: Easing.OutQuint;
            onStopped: flickable.contentX = Qt.binding(function() { return to; })
        }
    }

    Row {
        id: bottomRow;
        height: 80*dp;
        spacing: 8*dp;
        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom;
        }

        Repeater {
            model: pageRow.count;

            Rectangle {
                width: 8*dp;
                height: width;
                radius: width;
                color: Palette.theme.primaryText;
                opacity: index == pageRow.position ? 1 : 0.5;
                Behavior on opacity { PropertyAnimation { duration: 200; } }
                anchors { verticalCenter: parent ? parent.verticalCenter : undefined; }
            }
        }
    }

    function isOnPage(x) {
        var diff = flickable.contentX - x;
        return diff > -flickable.width && diff < flickable.width;
    }
}

