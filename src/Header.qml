import QtQuick 2.0
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Row {
    id: header

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    height: parent.height * 0.075

    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005

    property string title
    signal backClicked();

    z: 10

    Controls.BackButton {
        id: backBtn
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.2
        color: Constants.LAMA_ORANGE
        onClicked: backClicked()
    }

    Marker {
        id: labelTitle
        centerText: header.title
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.8
        color: Constants.LAMA_ORANGE
    }
}
