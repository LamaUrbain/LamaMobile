import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants

RowLayout {
    property bool deletable: false
    property alias waypointDescription: waypointText.centerText
    property alias waypointProperties: waypointText.navigationTargetProperties

    Component.onCompleted: {
        if (deletable === true)
            deleteLabel.visible = true
        else
            deleteLabel.visible = false
    }

    signal deleted()

    function raiseDeleted()
    {
        deleted()
    }

    NavigationButton {
        id: waypointText
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.fillWidth: true
        navigationTarget: "Suggestions"
    }

    DeleteButton {
        id: deleteLabel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.minimumWidth: parent.width * 0.1
        Layout.maximumWidth: parent.width * 0.15
        Layout.preferredWidth: parent.width * 0.12
        onDeleted: {
            raiseDeleted()
        }
    }
}
