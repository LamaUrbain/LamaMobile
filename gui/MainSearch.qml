import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {

    Components.Header {
        id: header
        title: "Search"
    }

    ListModel {
        id: waypointsModel

        ListElement {
            waypointData: "Departure"
        }
        ListElement {
            waypointData: "Here"
        }
        ListElement {
            waypointData: "There"
        }
        ListElement {
            waypointData: "Further"
        }
        ListElement {
            waypointData: "Arrival"
        }
    }

    ScrollView {
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.8
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        ListView {
            model: waypointsModel
            delegate: Components.Waypoint {
                height: search.height * 0.09
                waypointDescription: waypointData
                anchors.left: parent.left
                anchors.right: parent.right
                waypointProperties: {
                    "waypointData": waypointData,
                }
                deletable: index == 0 ? false : true
                onDeleted: {
                    waypointsModel.remove(index)
                }
            }
            footer: Controls.Button {
                height: search.height * 0.09
                centerText: "Add destination"
                onClicked: {
                    waypointsModel.append({"waypointData": "New Waypoint"})
                }
            }
        }
    }

    Components.BottomAction {
        id: launch

        RowLayout {
            anchors.fill: parent
            spacing: 2

            Controls.IconButton {
                id: shareButton
                Layout.fillWidth: true
                text: "Share"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                height: parent.height
                iconSource: Constants.LAMA_SHARE_RESSOURCE
            }

            Controls.IconButton {
                checkable: true
                id: modifyButton
                Layout.fillWidth: true
                text: "Save"
                iconSource: Constants.LAMA_SAVE_RESSOURCE
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                height: parent.height
            }

            Controls.NavigationButton {
                id: deleteButton
                Layout.fillWidth: true
                centerText: "Launch"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                navigationTarget: "Map"
            }
        }
    }

}
