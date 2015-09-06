import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import QtPositioning 5.3
import QtLocation 5.3

import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {
    id: waypointSuggestions

    property var currentWaypoint: ViewsLogic.getPtFromIndex(rootView.lamaSession.CURRENT_WAYPOINT_ID,
                                                rootView.lamaSession.CURRENT_ITINERARY)
    Components.Header
    {
        id: header
    }

    PlaceSearchModel {
        id: suggestionPlace
        plugin: geoPlugin
        limit: 4

        searchArea: QtPositioning.circle(QtPositioning.coordinate(48.8555, 2.35039), 1000)

        onSearchTermChanged: update()

        Component.onCompleted: update()

        onStatusChanged: {
            if (status === PlaceSearchModel.Ready)
            {
                console.debug("Request ready: %1 results".arg(count))
                for (var i = 0; i < count; ++i)
                {
                    var place = data(i, "title");
                    console.debug("place [%1/%2]".arg(i + 1).arg(count), place)

                    if (place !== "")
                        suggestionsModel.append({'term': place})
                }
            }
            else if (suggestionPlace.status === PlaceSearchModel.Error)
            {
                console.log("error:", errorString())
            }
            else if (status == PlaceSearchModel.Loading)
            {
                console.debug("loading", searchTerm)
            }
        }
    }

    ListModel {
        id: suggestionsModel

        Component.onCompleted: {
            ViewsLogic.fillHistory(suggestionsModel, 4)
        }
    }

    ColumnLayout {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.8
        spacing: 2
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Components.TextField {
            id: addressInput
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.preferredHeight: parent.height * 0.1
            placeholderText: "Address"

            Component.onCompleted:
            {
                if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "address") === true)
                    text = currentWaypoint["address"]
            }

            onTextChanged: {
                suggestionPlace.searchTerm = addressInput.text
                ViewsLogic.fillHistoryFiltered(suggestionsModel, addressInput.text, 4)
            }

            onAccepted: {
                ViewsLogic.addToHistory(addressInput.text)
            }
        }

        Rectangle
        {
            Layout.preferredHeight: parent.height * 0.1
            anchors.left: parent.left
            anchors.right: parent.right
            color: "Transparent"

            Components.TextField
            {
                id: latitudeInput
                width: parent.width * 0.495
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                placeholderText: "Latitude"
                Component.onCompleted:
                {
                    if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "latitude") === true)
                        text = currentWaypoint["latitude"]
                }
                validator: RegExpValidator { regExp: /^(\-?\d{1,2}(\.\d+)?)$/ }
            }
            Components.TextField
            {
                id: longitudeInput
                width: parent.width * 0.495
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                placeholderText: "Longitude"
                Component.onCompleted:
                {
                    if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "longitude") === true)
                        text = currentWaypoint["longitude"]
                }
                validator: RegExpValidator { regExp: /^(\-?1?\d{1,2}(\.\d+)?)$/ }
            }
        }

        Component {
            id: suggestionDelegate

            Components.Marker {
                id: suggestion
                width: suggestionsView.width
                height: suggestion.paintedHeight * 1.25

                centerText: term
                onClicked: {
                    addressInput.text = term
                }
            }
        }

        ListView {
            id: suggestionsView
            model: suggestionsModel
            delegate: suggestionDelegate
            Layout.fillHeight: true
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    Components.BottomAction {
        Controls.Button {
            centerText: "Validate"
            anchors.fill: parent
            onClicked: {
                var id = rootView.lamaSession.CURRENT_WAYPOINT_ID
                var longitude = longitudeInput.text
                var latitude = latitudeInput.text
                var areCardinalsHere = longitude.length > 0 || latitude.length > 0
                if (id < 0 // cheating
                    || (areCardinalsHere && (Math.abs(longitude) > 180 || Math.abs(latitude) > 90)))
                {
                    mainModal.title = "Wrong values"
                    mainModal.message = "Latitude must be between -90 and 90\n"
                                      + "Longitude must be between -180 and 180"
                    mainModal.visible = true
                    return;
                }

                var waypointKind
                if (id > 0)
                {
                    waypointKind = "destinations"
                    --id;
                    if (areCardinalsHere)
                    {
                        rootView.lamaSession.CURRENT_ITINERARY[waypointKind][id]["longitude"] = longitude
                        rootView.lamaSession.CURRENT_ITINERARY[waypointKind][id]["latitude"] = latitude
                    }
                    rootView.lamaSession.CURRENT_ITINERARY[waypointKind][id]["address"] = addressInput.text
                }
                else
                {
                    waypointKind = "departure"
                    if (areCardinalsHere)
                    {
                        rootView.lamaSession.CURRENT_ITINERARY[waypointKind]["longitude"] = longitude
                        rootView.lamaSession.CURRENT_ITINERARY[waypointKind]["latitude"] = latitude
                    }
                    rootView.lamaSession.CURRENT_ITINERARY[waypointKind]["address"] = addressInput.text
                }

                rootView.raiseUserSessionChanged()
                var currentRoute = rootView.lamaSession.CURRENT_ITINERARY
                if ("favorite" in currentRoute && currentRoute["favorite"] === true)
                {
                    var idx = ViewsLogic.getIndexItineraryKnown(rootView.lamaSession.KNOWN_ITINERARIES, currentRoute)
                    if (idx >= 0)
                    {
                        rootView.lamaSession.KNOWN_ITINERARIES[idx] = currentRoute;
                        UserSession.saveSessionState(rootView.lamaSession)
                    }
                }
                rootView.mainViewBack();
            }
        }
    }
}
