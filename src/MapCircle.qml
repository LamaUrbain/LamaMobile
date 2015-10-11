import QtQuick 2.0
import "qrc:/Controls" as Controls

Controls.MapItem {
    id: mapCircle
    sourceItem: circleItem

    property alias radius: circleItem.radius
    property alias color: circleItem.color

    Rectangle {
        id: circleItem

        width: radius * 2
        height: width
    }
}
