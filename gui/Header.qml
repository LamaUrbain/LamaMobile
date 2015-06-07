import QtQuick 2.0
import "qrc:/Controls/" as Controls

Marker {
    id: header
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: parent.height * 0.075
    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005

    property string title

    Row {
        anchors.fill: parent

        Controls.BackButton {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.2
        }

        Marker {
            id: labelTitle
            centerText: header.title
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.8
        }
    }

}
