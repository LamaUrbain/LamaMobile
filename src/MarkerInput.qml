import QtQuick 2.5
import "qrc:/Constants.js" as Constants

MarkerArea {
    id: input
    hoverable: true

    property color color1: Constants.LAMA_YELLOW
    property color color2: Constants.LAMA_ORANGE
    property color borderColor1: Constants.LAMA_BORDER_COLOR
    property color borderColor2: Constants.LAMA_BORDER_COLOR2
    property int borderWidth: 1
    property int radius: 5

    Rectangle {
        id: rect
        anchors.fill: parent
        border.width: input.borderWidth
        border.color: input.hoverable && input.pressed ? input.borderColor2 : input.borderColor1
        color: input.hoverable && input.pressed ? input.color2 : input.color1
        opacity: enabled ? 1 : 0.6
        radius: input.radius
    }
}
