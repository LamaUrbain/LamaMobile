import QtQuick 2.5
import "qrc:/Constants.js" as Constants

Rectangle {
    color: Constants.LAMA_BACKGROUND
    radius: 0

    MouseArea {
        anchors.fill: parent
        onClicked: focus = true;
        onWheel: wheel.accepted = true;
        preventStealing: true
    }
}
