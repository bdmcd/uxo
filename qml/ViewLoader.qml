import QtQuick 2.5
import 'qrc:/views';

Rectangle {
    id: main;
    color: item.color;

    property View item;
    property int status;
    property bool asynchronous;
    property bool loading;

    signal loaded();

    function setSource(source, properties) {
        main.loading = true;
        properties = properties || {};
        var component = Qt.createComponent(source);
        if (component.status === Component.Ready) {
            if (main.item) { main.item.enabled = false; }
            properties.visible = false;
            var syncMode = asynchronous ? Qt.Asynchronous : Qt.Synchronous;
            _private.incubator = component.incubateObject(main, properties, syncMode);
        }
        else if (component.status === Component.Error) {
            console.log(component.errorString())
        }
    }

    QtObject {
        id: _private;

        property var incubator;
        onIncubatorChanged: {
            if (incubator.status !== Component.Ready) {
                incubator.onStatusChanged = function(status) {
                    main.status = status;
                    if (status === Component.Ready) {
                        loaded();
                    }
                }
            }
            else {
                loaded();
            }
        }

        function loaded() {
            if (main.item) { main.item.destroy(); }
            main.item = incubator.object;
            main.item.visible = true;
            main.loaded();
            main.loading = false;
        }
    }
}

