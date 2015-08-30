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
        ViewsLogic.fillWaypoints(waypointsModel, rootView.lamaSession.CURRENT_ITINERARY)
    }

    Component.onCompleted: rootView.onUserSessionChanged.connect(refreshModel)
    Component.onDestruction: rootView.onUserSessionChanged.disconnect(refreshModel)

    Components.Header {
        id: header
        title: "Search"
        onBackClicked:
        {
            if (rootView.lamaSession.CURRENT_ITINERARY["name"] !== nameInput.text)
            {
                rootView.lamaSession.CURRENT_ITINERARY["name"] = nameInput.text;
                var idxKnown = ViewsLogic.getIndexItineraryKnown(rootView.lamaSession.KNOWN_ITINERARIES, rootView.lamaSession.CURRENT_ITINERARY);
                if (idxKnown >= 0)
                {
                    rootView.lamaSession.KNOWN_ITINERARIES[idxKnown] = rootView.lamaSession.CURRENT_ITINERARY;
                    rootView.raiseUserSessionChanged()
                }
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
            if (ViewsLogic.isValueAtKeyValid(rootView.lamaSession.CURRENT_ITINERARY, "name"))
                text = rootView.lamaSession.CURRENT_ITINERARY["name"]
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
                    rootView.lamaSession.CURRENT_ITINERARY["destinations"].splice(index, 1)
                }
            }
            footer: Controls.ImageButton {
                iconSource: Constants.LAMA_ADD_RESSOURCE
                height: search.height * (0.09 + 0.02)
                width: search.width * (0.10 + 0.02)
                onClicked: {
                    var newDest = {address: "New Waypoint"}
                    waypointsModel.append({waypointData: newDest})
                    if (!ViewsLogic.isValueAtKeyValid(rootView.lamaSession.CURRENT_ITINERARY, "destinations"))
                        rootView.lamaSession.CURRENT_ITINERARY["destinations"] = ([]);
                    rootView.lamaSession.CURRENT_ITINERARY["destinations"].push(newDest)
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
            }

            Controls.IconButton {
                property bool saved: false

                onClicked: {
                    rootView.lamaSession.CURRENT_ITINERARY["name"] = nameInput.text;

                    rootView.lamaSession.CURRENT_ITINERARY["favorite"] = !rootView.lamaSession.CURRENT_ITINERARY["favorite"]
                    var isFavorited = rootView.lamaSession.CURRENT_ITINERARY["favorite"]

                    iconSource = isFavorited ? Constants.LAMA_SAVED_RESSOURCE: Constants.LAMA_SAVE_RESSOURCE

                    var idxKnown = ViewsLogic.getIndexItineraryKnown(rootView.lamaSession.KNOWN_ITINERARIES, rootView.lamaSession.CURRENT_ITINERARY);

                    if (isFavorited && idxKnown < 0)
                    {
                        rootView.lamaSession.CURRENT_ITINERARY['id'] = -(Math.round(Date.now() / 1000) % 100000000)
                        rootView.lamaSession.KNOWN_ITINERARIES.push(rootView.lamaSession.CURRENT_ITINERARY)
                    }
                    else if (idxKnown >= 0)
                    {
                        if (isFavorited)
                            rootView.lamaSession.KNOWN_ITINERARIES[idxKnown] = rootView.lamaSession.CURRENT_ITINERARY;
                        else
                            rootView.lamaSession.KNOWN_ITINERARIES.splice(idxKnown, 1);
                    }

                    rootView.raiseUserSessionChanged()
                    UserSession.saveSessionState(rootView.lamaSession)
                    // edit itineraryServices in raiseusersessionchanged
                    //itineraryServices.editItinerary(int id, QString name, QString departure, QString favorite, ServicesBase::CallbackType callback);
                }

                id: modifyButton
                Layout.fillWidth: true
                text: "Save"
                iconSource: rootView.lamaSession.CURRENT_ITINERARY["favorite"] ? Constants.LAMA_SAVED_RESSOURCE: Constants.LAMA_SAVE_RESSOURCE
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
                    if (rootView.lamaSession.CURRENT_ITINERARY["name"] !== nameInput.text)
                    {
                        rootView.lamaSession.CURRENT_ITINERARY["name"] = nameInput.text;
                        rootView.raiseUserSessionChanged()
                    }

                    rootView.resolveCurrentItinerary()
                }
            }
        }
    }

}
