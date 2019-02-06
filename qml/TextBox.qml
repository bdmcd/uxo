import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import palette 1.0

TextField {
    id: main;
    font.pixelSize: height*0.5;
    textColor: Palette.theme.primaryText;

    signal enterPressed();

    property bool nextOnEnter: true;
    property color selectionColor: textColor;
    property color selectedTextColor: Color.invert(selectionColor);
    property color placeholderTextColor: Color.setAlpha(textColor, 0.5);
    property color backgroundColor: Color.setAlpha("black", 0.3);
    property bool error: false;

    style: TextFieldStyle {
        font: main.font;
        textColor: main.textColor;
        selectionColor: main.selectionColor;
        selectedTextColor: main.selectedTextColor;
        placeholderTextColor: main.placeholderTextColor
        passwordCharacter: "•"
        background: Rectangle {
            color: main.backgroundColor
            anchors { fill: parent; }
            radius: height*0.1;
            property bool error: main.error && main.length == 0;
            border.width: error ? 2*dp : 0;
            border.color: error ? "red" : "transparent";
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
            if (nextOnEnter) {
                nextItemInFocusChain().forceActiveFocus();
            }
            enterPressed();
            event.accepted = true;
        }
        else if (event.key == Qt.Key_Back || event.key == Qt.Key_Escape) {
            App.keyHandler.forceActiveFocus();
            Qt.inputMethod.hide();
            event.accepted = true;
        }
    }

    onFocusChanged: {
        if (focus) {
            App.toolbar.copyRow.copyText = this;
        }
    }
}

