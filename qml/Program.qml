import QtQuick 2.5
import "qrc:/components"
import "qrc:/views"
import "qrc:/gui"

Item {
    id: main;
    enabled: !viewLoader.loading;
    anchors { fill: parent; }

    property Item keyHandler;
    property string logoString: "U<font size='4'>X</font>O";
    property alias view: viewLoader.item;
    property alias toolbar: toolbar;
    property alias dropdown: dropdown;
    property bool isMobile: Qt.platform.os == "android" || Qt.platform.os == "ios";

    ViewLoader {
        id: viewLoader;
        asynchronous: true;
        anchors { fill: parent; }
    }

    Toolbar {
        id: toolbar;
    }

    DropdownMenu {
        id: dropdown;
    }

    function changeView(name, properties) {
        dropdown.hide(false);
        keyHandler.forceActiveFocus();
        viewLoader.setSource("qrc:/views/" + name + ".qml", properties || {});
    }

    Component.onCompleted: {
        changeView("Home");
    }
}

