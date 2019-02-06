import QtQuick 2.5

Flickable {
    id: main;
    contentWidth: Math.max(width, targetSize.width);
    contentHeight: Math.max(height, targetSize.height);

    property Item target;
    property double minScale: 1;
    property double maxScale: 3;
    readonly property size targetSize: Qt.size(target.width*target.scale, target.height*target.scale);

    PinchArea {
        id: pinchArea;
        x: main.contentX;
        y: main.contentY;
        width: main.width
        height: main.height

        onPinchUpdated: {
            var scale = Math.min(Math.max(target.scale + pinch.scale - pinch.previousScale, minScale), maxScale);
            var width = targetSize.width;
            var height = targetSize.height;
            var pos = getPinchCenter(pinch.center, scale);

            target.scale = scale;

            var center = getContentCenter(pos, targetSize.width, targetSize.height, width, height);
            contentX += center.x;
            contentY += center.y;
        }

        function getPinchCenter(center, scale) {
            var pos = mapToItem(target, center.x, center.y);
            pos.x = pos.x*scale;
            pos.y = pos.y*scale;
            return pos;
        }

        function getContentCenter(pos, width, height, oldWidth, oldHeight) {
            var xPercent = pos.x/width;
            var yPercent = pos.y/height;
            var widthDiff = width - oldWidth;
            var heightDiff = height - oldHeight;

            return { x: widthDiff*xPercent, y: heightDiff*yPercent }
        }

        onPinchFinished: {
            main.interactive = true;
            main.returnToBounds();
        }

        PropertyAnimation {
            id: zoomAnim;
            target: main.target;
            property: 'scale';
            duration: 400;
            easing.type: Easing.OutQuart;
        }
        PropertyAnimation {
            id: xAnim;
            target: main;
            property: 'contentX';
            running: zoomAnim.running;
            duration: zoomAnim.duration;
            easing: zoomAnim.easing;
        }
        PropertyAnimation {
            id: yAnim;
            target: main;
            property: 'contentY';
            running: zoomAnim.running;
            duration: zoomAnim.duration;
            easing: zoomAnim.easing;
        }

        MouseArea {
            anchors { fill: parent; }
            onDoubleClicked: main.zoom(mouse, this);
            onPressAndHold: main.zoom(mouse, this);
        }
    }

    function zoom(center, item) {
        center = item.mapToItem(main, center.x, center.y);
        var zoomIn = target.scale == main.minScale;
        var scale = zoomIn ? main.maxScale : main.minScale;
        var pos = pinchArea.getPinchCenter({ x: center.x, y: center.y}, scale);
        var contentCenter = pinchArea.getContentCenter(pos, target.width*scale, target.height*scale, targetSize.width, targetSize.height);

        xAnim.to = zoomIn ? main.contentX + contentCenter.x : 0;
        yAnim.to = zoomIn ? main.contentY + contentCenter.y : 0;
        zoomAnim.to = scale;
        zoomAnim.start();
    }

    Component.onCompleted: {
        target.transformOrigin = Item.TopLeft;
    }
}

