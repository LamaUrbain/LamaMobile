import QtQuick 2.0
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
    property alias centerFont: centerLabel.font
    property bool checkable: false
    property bool checked: false
    property bool hoverable: false
    property bool hovered: false
    property color color: Constants.LAMA_YELLOW
    property string icon
    property alias iconSource: image.source
    property alias pressed: area.pressed
    property real radius: 20

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: root.color
        opacity: root.hovered ? 0.5 : root.checked ? 0.9 : 1
        radius: parent.radius
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "transparent"
        opacity: 1.4
        border.width: 2
        border.color: Qt.darker(root.color, root.checked ? 1.4 : 1.2)
        radius: parent.radius
    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: root.icon
        sourceSize.width: 1024
        sourceSize.height: 1024
        transform: Scale {
           xScale: 0.79
           yScale: 0.79
        }
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
        font.pixelSize: 12
        renderType: Text.NativeRendering
        color: "white"
        text: root.text
    }

    Text {
        id: centerLabel
        anchors.centerIn: parent
        font.pixelSize: 12
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
