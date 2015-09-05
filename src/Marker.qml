import QtQuick 2.0
import QtGraphicalEffects 1.0
import "qrc:/Constants.js" as Constants

Item {
    id: root
    width: implicitWidth
    height: implicitHeight
    implicitWidth: 200
    implicitHeight: 200

    signal clicked();
    signal entered();
    signal exited();

    property string text: objectName
    property alias centerText: centerLabel.text
    property bool checkable: false
    property bool checked: false
    property bool hoverable: false
    property bool hovered: false
    property color color: Constants.LAMA_YELLOW
    property string icon
    property alias iconSource: image.source
    property alias pressed: area.pressed
    property real radius: 20

    property var colorGradient: Gradient {
        GradientStop { position: 0.0; color: Qt.lighter(root.color, 1.2)}
        GradientStop { position: 1.0; color: root.color}
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: Qt.darker(root.color, root.checked ? 1.1 : 1)
        opacity: root.hovered ? 0.5 : root.checked ? 0.9 : 1
        radius: parent.radius
        gradient: colorGradient
    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: root.icon
    }

    Rectangle {
        anchors.fill: label
        anchors.leftMargin: -8
        anchors.rightMargin: -2
        anchors.topMargin: -2
        anchors.bottomMargin: -2
        visible: label.text
        opacity: 0.05
        border.color: Qt.lighter(color, 1.2)
        radius: parent.radius
    }

    Text {
        id: label
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2
        font.pointSize: 20.0
        renderType: Text.NativeRendering
        color: "white"
        text: root.text
    }

    Text {
        id: centerLabel
        anchors.centerIn: parent
        font.pointSize: 20.0
        renderType: Text.NativeRendering
        color: "white"
        text: root.centerText
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: {
            if (root.checkable)
                root.checked = !root.checked;
            else
                root.clicked();
            mouse.accepted = false
        }
        onEntered: {
            if (root.hoverable)
                root.hovered = true
            else
                root.entered();
        }
        onExited: {
            if (root.hoverable)
                root.hovered = false
            else
                root.entered();
        }
    }
}
