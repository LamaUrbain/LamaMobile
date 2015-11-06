import QtQuick 2.0
import "qrc:/Controls" as Controls

Controls.MapItem {
    id: mapCircle
    sourceItem: circleItem

    property alias radius: circleItem.radius
    property alias color: circleItem.color
    property int borderWidth: 0
    property color borderColor: "transparent"

    Rectangle {
        id: circleItem
        width: radius * 2
        height: width
        border.width: mapCircle.borderWidth
        border.color: mapCircle.borderColor
    }
}
