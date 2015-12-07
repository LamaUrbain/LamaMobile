import QtQuick 2.5

Item {
    id: root
    width: implicitWidth
    height: implicitHeight
    implicitWidth: 200
    implicitHeight: 200

    signal clicked();
    signal entered();
    signal exited();

    property bool hoverable: false
    property alias hovered: area.containsMouse
    property alias pressed: area.pressed
    property bool checkable: false
    property bool checked: false

    MouseArea {
        id: area
        hoverEnabled: hoverable
        anchors.fill: parent
        onClicked: {
            if (root.checkable)
                root.checked = !root.checked;
            root.clicked();
            mouse.accepted = false;
        }
    }
}
