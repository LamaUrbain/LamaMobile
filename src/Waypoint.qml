import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants

RowLayout {
    property int linkedWaypointId: -1
    property alias waypointDescription: waypointText.centerText
    property bool deletable: false
    property bool readOnly: false

    anchors.left: parent.left
    anchors.right: parent.right

    Component.onCompleted: {
        if (readOnly == false)
        {
            if (deletable === true)
                deleteLabel.visible = true
            else
                deleteLabel.visible = false
        }
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
        navigationTargetProperties: {'readOnly': readOnly}
        onNavButtonPressed:
        {
            rootView.lamaSession.CURRENT_WAYPOINT_ID = linkedWaypointId
        }
    }

    DeleteButton {
        id: deleteLabel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.minimumWidth: parent.width * 0.1
        Layout.maximumWidth: parent.width * 0.15
        Layout.preferredWidth: parent.width * 0.12
        visible: readOnly == false
        onDeleted: {
            raiseDeleted()
        }
    }
}
