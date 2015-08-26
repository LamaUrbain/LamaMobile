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
        onBackClicked:
        {
            if (UserSession.LAMA_USER_CURRENT_ITINERARY["name"] !== nameInput.text)
            {
                UserSession.LAMA_USER_CURRENT_ITINERARY["name"] = nameInput.text;
                rootView.raiseUserSessionChanged()
            }
        }
    }

    ListModel {
        id: waypointsModel

        Component.onCompleted : refreshModel()
    }


    Components.TextField {
        id: nameInput
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.05
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005

        placeholderText: "Name"
        Component.onCompleted:
        {
            if (ViewsLogic.isValueAtKeyValid(UserSession.LAMA_USER_CURRENT_ITINERARY, "name"))
                text = UserSession.LAMA_USER_CURRENT_ITINERARY["name"]
        }
    }

    ScrollView {
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: nameInput.bottom
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
                    if (!ViewsLogic.isValueAtKeyValid(UserSession.LAMA_USER_CURRENT_ITINERARY, "destinations"))
                        UserSession.LAMA_USER_CURRENT_ITINERARY["destinations"] = ([]);
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

            Controls.ShareButton {
                id: shareButton
                Layout.fillWidth: true
                itinerary: UserSession.LAMA_USER_CURRENT_ITINERARY
            }

            Controls.IconButton {
                property bool saved: false

                onClicked: {
                    UserSession.LAMA_USER_CURRENT_ITINERARY["name"] = nameInput.text;

                    UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"] = !UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"]
                    var isFavorited = UserSession.LAMA_USER_CURRENT_ITINERARY["favorite"]

                    iconSource = isFavorited ? Constants.LAMA_SAVED_RESSOURCE: Constants.LAMA_SAVE_RESSOURCE

                    var idxKnown = ViewsLogic.getIndexItineraryKnown(UserSession.LAMA_USER_KNOWN_ITINERARIES, UserSession.LAMA_USER_CURRENT_ITINERARY);

                    if (isFavorited && idxKnown < 0)
                        UserSession.LAMA_USER_KNOWN_ITINERARIES.push(UserSession.LAMA_USER_CURRENT_ITINERARY)
                    else if (!isFavorited && idxKnown >= 0)
                        delete UserSession.LAMA_USER_KNOWN_ITINERARIES[idxKnown];

                    rootView.raiseUserSessionChanged()
                    // edit itineraryServices in raiseusersessionchanged
                    //itineraryServices.editItinerary(int id, QString name, QString departure, QString favorite, ServicesBase::CallbackType callback);
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
                Layout.fillWidth: true
                centerText: "Launch"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                navigationTarget: "Map"
                onNavButtonPressed:
                {
                    if (UserSession.LAMA_USER_CURRENT_ITINERARY["name"] !== nameInput.text)
                    {
                        UserSession.LAMA_USER_CURRENT_ITINERARY["name"] = nameInput.text;
                        rootView.raiseUserSessionChanged()
                    }

                    rootView.resolveCurrentItinerary()
                }
            }
        }
    }

}
