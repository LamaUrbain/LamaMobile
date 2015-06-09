import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"

Marker {
    property bool deletable: false
    property alias waypointDescription: waypointText.centerText
    property alias waypointProperties: waypointText.navigationTargetProperties

    Component.onCompleted: {
        if (deletable === true)
            deleteLabel.visible = true
        else
            deleteLabel.visible = false
    }

    RowLayout {
        anchors.fill: parent
        NavigationButton {
            id: waypointText
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.fillWidth: true
            navigationTarget: "Suggestions"
        }
        Marker {
            id: deleteLabel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.1
            centerText: "delete"
        }
    }
}
