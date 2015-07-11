import QtQuick 2.0
import "qrc:/Components/" as Components

Components.Marker {
    id: background
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    // header
    Components.Header {
        id: header
        title: "Alert"
    }

    Column {
        id: body
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.9
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Components.Marker {
            id: alertTitle
            centerText: "Alert Title"
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.10
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
        }

        Components.Marker {
            id: alertDescription
            centerText: "Alert Description"
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.89
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
        }
    }
}
