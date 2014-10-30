import QtQuick 2.2
import QtQuick.Window 2.1
import Tests 1.0

Window {
    visible: true
    width: 900
    height: 900

    QuadtreeTestRenderer {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: parent.addRect(Qt.point(mouse.x, mouse.y));
        }
    }
}
