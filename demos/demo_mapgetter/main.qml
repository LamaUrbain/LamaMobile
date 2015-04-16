import QtQuick 2.2
import QtQuick.Window 2.1
import Tests 1.0

Window {
    visible: true
    width: 360
    height: 360

    MapWidget {
        id: mapWidget
        anchors.fill: parent
    }

    Rectangle {
        width: mapWidget.width / 2
        height: mapWidget.height / 2
        color: "red"
        opacity: 0.5
    }
}
