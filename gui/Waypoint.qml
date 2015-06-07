import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

Marker {
    property bool deletable: false
    property alias placeholderText: waypointText.placeholderText

    Component.onCompleted: {
        if (deletable === true)
            deleteLabel.visible = true
        else
            deleteLabel.visible = false
    }

    RowLayout {
        anchors.fill: parent
        Marker {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.fillWidth: true

            TextField {
                id: waypointText
                anchors.fill: parent
                anchors.leftMargin: parent.width * 0.02
                anchors.rightMargin: parent.width * 0.02

                anchors.topMargin: parent.height * 0.1
                anchors.bottomMargin: parent.height * 0.1
                placeholderText: "Enter Destination"
                opacity: 0.9
            }
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
