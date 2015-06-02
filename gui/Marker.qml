import QtQuick 2.0

Item {
    id: root
    width: implicitWidth
    height: implicitHeight
    implicitWidth: 200
    implicitHeight: 200

    signal clicked();

    property string text: objectName
    property string centerText
    property bool checkable: false
    property bool checked: false
    property color color: "#165B8C"
    property string icon
    property alias iconSource: image.source
    property alias pressed: area.pressed

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: root.color
        opacity: root.checked ? 0.4 : 0.2
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "transparent"
        opacity: 0.4
        border.width: 1
        border.color: Qt.darker(root.color, root.checked ? 0.4 : 0.2)
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
    }
}
