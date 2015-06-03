import QtQuick 2.0

Marker {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: parent.height * 0.075
    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005

    property string title

    Marker {
        id: backToMapButton
        centerText: "Back"
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width * 0.2
        anchors.bottom: parent.bottom
        onClicked: {
            mainView.changeViewTo("Map")
        }
    }

    Marker {
        id: labelTitle
        centerText: parent.title
        anchors.left: backToMapButton.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
