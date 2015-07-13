import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession

import QtLocation 5.3
import QtPositioning 5.2

Components.Marker {
    id: mapView

    Components.Marker {
        id: header
        z: 1
        color: "transparent"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * 0.1
        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.005
        Layout.maximumHeight: parent.height * 0.075
        Layout.minimumHeight: parent.height * 0.075
        RowLayout {
            anchors.fill: parent

            Controls.NavigationButton {
                Layout.fillWidth: true
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                centerText: "Search"
                navigationTarget: "MainSearch"
                color: Constants.LAMA_ORANGE
            }

            Controls.NavigationButton {
                Layout.fillWidth: true
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                centerText: "Menu"
                navigationTarget: "Menu"
                color: Constants.LAMA_ORANGE
            }

            Controls.NavigationButton {
                Layout.fillWidth: true
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                centerText: "User Auth"
                navigationTarget: "UserAuth"
                color: Constants.LAMA_ORANGE
            }
        }
    }

    Map {
        id: map

        zoomLevel: 12

        gesture.flickDeceleration: 3000
        gesture.enabled: true

        plugin: Plugin {
            name: "osm"
        }

        property GeocodeModel geocodeModel: GeocodeModel {
            plugin: map.plugin
        }

        anchors.fill: parent
        center {
            latitude: 48.85341
            longitude: 2.3488
        }

        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.005
        Controls.ImageButton {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width * (0.10 + 0.04)
            height: parent.height * (0.10 + 0.02)
            iconSource: Constants.LAMA_ADD_RESSOURCE
            onClicked:
            {
                UserSession.LAMA_USER_CURRENT_ITINERARY = ({})
                rootView.mainViewTo("MainSearch", null)
            }
        }
    }

    function resolveCurrentItinerary()
    {
        /*********temporary due to lack of addr resolving*********/
        var startPoint = UserSession.LAMA_USER_CURRENT_ITINERARY["departure"]
        var lastId = UserSession.LAMA_USER_CURRENT_ITINERARY["destinations"].length - 1
        var arrivalPoint = UserSession.LAMA_USER_CURRENT_ITINERARY["destinations"][lastId]
        var requestDeparture = startPoint["latitude"] + ',' + startPoint["longitude"]
        var requestArrival = arrivalPoint["latitude"] + ',' + arrivalPoint["longitude"]

        /*departure = departure.split(new RegExp("[,;] *"));
        departure = departure[0] + ',' + departure[1];
        if (arrival)
        {
            arrival = arrival.split(new RegExp("[,;] *"));
            arrival = arrival[0] + ',' + arrival[1];
        }*/
        /********************************************************/

        var name = "tempItinerary" + (Date.now());

        //itineraryServices.abortPendingRequests()
        itineraryServices.createItinerary(name, requestDeparture, requestArrival, false, function(mainModal)
        {
            return (function(statusCode, jsonStr)
            {
                console.log("CreateItinerary Response Status : " + statusCode);
                if (statusCode === 0)
                {
                    var jsonObj = JSON.parse(jsonStr)
                    console.log("CreateItinerary Response Id : " + jsonObj["id"]);
                    mapView.mapComponent.displayItinerary(jsonObj["id"]);
                }
                else
                {
                    mainModal.title = "Error"
                    mainModal.message = "Unfortunatly the llama did not find his way"
                    mainModal.enableButton = true
                    mainModal.setLoadingState(false)
                }
            });
        }(mainModal));

        // Todo : get an itinerary that already exists
        mainModal.title = "Resolving itinierary"
        mainModal.setLoadingState(true)
        mainModal.enableButton = false
        mainModal.visible = true
    }
}
