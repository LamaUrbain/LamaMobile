import QtQuick 2.5
import QtGraphicalEffects 1.0
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
