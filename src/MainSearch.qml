import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {

    function refreshModel()
    {
        ViewsLogic.fillWaypoints(waypointsModel, UserSession.LAMA_USER_CURRENT_ITINERARY)
    }

    Component.onCompleted: rootView.onUserSessionChanged.connect(refreshModel)
    Component.onDestruction: rootView.onUserSessionChanged.disconnect(refreshModel)

    Components.Header {
        id: header
        title: "Search"
    }

    ListModel {
        id: waypointsModel

        Component.onCompleted : refreshModel()
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
                waypointDescription: waypointData.address === null ? 'Departure' : waypointData.address
                linkedWaypointId: index
                deletable: index == 0 ? false : true
                onDeleted:
                {
                    waypointsModel.remove(index)
                    delete UserSession.LAMA_USER_CURRENT_ITINERARY["destinations"][index]
                }
            }
            footer: Controls.ImageButton {
                iconSource: Constants.LAMA_ADD_RESSOURCE
                height: search.height * (0.09 + 0.02)
                width: search.width * (0.10 + 0.02)
                onClicked: {
                    var newDest = {address: "New Waypoint"}
                    waypointsModel.append({waypointData: newDest})
                    UserSession.LAMA_USER_CURRENT_ITINERARY["destinations"].push(newDest)
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
                property bool saved: false

                onClicked: {
                    UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"] = !UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"]
                    iconSource = UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"] ? Constants.LAMA_SAVED_RESSOURCE: Constants.LAMA_SAVE_RESSOURCE
                }

                id: modifyButton
                Layout.fillWidth: true
                text: "Save"
                iconSource: UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"] ? Constants.LAMA_SAVED_RESSOURCE: Constants.LAMA_SAVE_RESSOURCE
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
                onNavButtonPressed:
                {
                    rootView.resolveCurrentItinerary()
                }
            }
        }
    }

}
