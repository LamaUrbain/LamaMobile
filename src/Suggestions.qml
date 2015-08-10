import QtQuick 2.0
import QtQuick.Controls 1.3
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {
    id: waypointSuggestions

    property var currentWaypoint: ViewsLogic.getPtFromIndex(UserSession.LAMA_USER_CURRENT_WAYPOINT_ID,
                                                UserSession.LAMA_USER_CURRENT_ITINERARY)
    Components.Header
    {
        id: header
        title: "Suggestions of places"
    }

    Column {
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
            height: parent.height * 0.1
            placeholderText: "Address"
            Component.onCompleted:
            {
                if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "address"))
                    text = currentWaypoint["address"]
            }
        }

        Rectangle
        {
            height: parent.height * 0.1
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
                    if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "latitude"))
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
                    if (ViewsLogic.isValueAtKeyValid(currentWaypoint, "longitude"))
                        text = currentWaypoint["longitude"]
                }
                validator: RegExpValidator { regExp: /^(\-?1?\d{1,2}(\.\d+)?)$/ }
            }
        }

        Column {
            id: choices
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.55

            Components.Marker {
                id: suggestions
                centerText: "Suggestions"
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height * 0.33
            }

            Components.Marker {
                id: favorites
                centerText: "Favorites"
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.33
            }

            Components.Marker {
                id: history
                centerText: "History"
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.33
            }
        }
    }

    Components.BottomAction {
        Controls.Button {
            centerText: "Validate"
            anchors.fill: parent
            onClicked: {
                var id = UserSession.LAMA_USER_CURRENT_WAYPOINT_ID
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
                        UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind][id]["longitude"] = longitude
                        UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind][id]["latitude"] = latitude
                    }
                    UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind][id]["address"] = addressInput.text
                }
                else
                {
                    waypointKind = "departure"
                    if (areCardinalsHere)
                    {
                        UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind]["longitude"] = longitude
                        UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind]["latitude"] = latitude
                    }
                    UserSession.LAMA_USER_CURRENT_ITINERARY[waypointKind]["address"] = addressInput.text
                }
                rootView.raiseUserSessionChanged()
                var currentRoute = UserSession.LAMA_USER_CURRENT_ITINERARY
                if ("favorite" in currentRoute && currentRoute["favorite"] === true)
                    UserSession.saveCurrentSessionState()
                rootView.mainViewBack();
            }
        }
    }
}
