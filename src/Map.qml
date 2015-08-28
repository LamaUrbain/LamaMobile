import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

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

    Map
    {
        id: map

        zoomLevel: 12

        gesture.flickDeceleration: 3000
        gesture.enabled: true

        plugin: Plugin {
            name: "osm"
            PluginParameter {
                name: "osm.mapping.copyright";
                value: null
            }
            PluginParameter {
                name: "osm.useragent";
                value: "LamaMobile";
            }
        }


        Component.onCompleted: {
            for (var i = 0; i < map.supportedMapTypes.length; ++i)
            {
                if (map.supportedMapTypes[i].style === MapType.CustomMap)
                {
                    map.activeMapType = map.supportedMapTypes[i]
                }
            }

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
                UserSession.LAMA_USER_CURRENT_ITINERARY = Constants.LAMA_BASE_ITINERARY_OBJ
                rootView.mainViewTo("MainSearch", null)
            }
        }

        MouseArea {
            id: mapArea
            anchors.fill: parent

            onClicked: {
                var pop = ViewsLogic.spawnPopOver(parent, mapArea.mouseX, mapArea.mouseY, "je suis une popup :3 !")
                mouse.accepted = false
                map.addMapItem(pop)
            }
        }
    }

    property var _currentResolutionWayPointCount;
    function proceedToAddWayPoints(itineraryId, wayPointsArray)
    {
        CurrentResolutionWayPointCount = 0;
        var wayPointCount = wayPointsArray.length; // Fucking flies because of dereferencement

        if (CurrentResolutionWayPointCount === wayPointCount)
            mapView.mapComponent.displayItinerary(jsonObj["id"]);
        else
        {
            for (var idx = 0; idx < wayPointCount; ++idx)
                itineraryServices.addDestination(itineraryId, wayPointsArray[idx], idx, function ()
                {
                    return (function(statusCode, jsonStr)
                    {
                        if (statusCode !== 0)
                        {
                            mainModal.title = "Error"
                            mainModal.text = "Sadly, an error occured (MAPVIEW_RESOLV_DEST_ADD_FAIL)"
                            mainModal.enableButton = true
                            mainModal.visible = true
                        }

                        if (++CurrentResolutionWayPointCount === wayPointCount)
                            mapView.mapComponent.displayItinerary(jsonObj["id"]);
                    });
                }());
        }
    }

    function updateItineraryAndDisplay()
    {
        console.log("TODO updateItinerary")

        mapView.mapComponent.displayItinerary(jsonObj["id"]);
    }

    function createItineraryAndDisplay()
    {
        var currentIt = UserSession.LAMA_USER_CURRENT_ITINERARY
        var startPoint = currentIt["departure"]
        var lastId = currentIt["destinations"].length - 1
        var arrivalPoint = currentIt["destinations"][lastId]
        var requestDeparture = startPoint["latitude"] + ',' + startPoint["longitude"]
        var requestArrival = arrivalPoint["latitude"] + ',' + arrivalPoint["longitude"]

        var waypointArray = [];
        if (lastId !== 0)
            for (var idx = 0; idx < lastId; ++idx)
            {
                var currentPoint = currentIt["destinations"][idx]
                waypointArray.push(currentPoint["latitude"] + ',' + currentPoint["longitude"])
            }

        if (currentIt['name'] === null || currentIt['name'] === '')
            currentIt['name'] = "tmp_itinerary_" + ViewsLogic.getRandomString(8);

        //itineraryServices.abortPendingRequests()
        itineraryServices.createItinerary(currentIt['name'], requestDeparture, requestArrival, currentIt["favorite"], function(mainModal)
        {
            return (function(statusCode, jsonStr)
            {
                console.log("CreateItinerary Response Status : " + statusCode);
                if (statusCode === 0)
                {
                    var jsonObj = JSON.parse(jsonStr)
                    var ItId = jsonObj["id"]
                    console.log("CreateItinerary Response Id : " + ItId);
                    UserSession.LAMA_USER_CURRENT_ITINERARY['id'] = ItId;
                    proceedToAddWayPoints(ItId, waypointArray)
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
    }

    function resolveCurrentItinerary()
    {
        mainModal.title = "Resolving itinierary"
        mainModal.setLoadingState(true)
        mainModal.enableButton = false
        mainModal.visible = true

        var currentIt = UserSession.LAMA_USER_CURRENT_ITINERARY;

        if (!ViewsLogic.isValueAtKeyValid(currentIt, "departure")
                || !ViewsLogic.isValueAtKeyValid(currentIt, "destinations"))
        {
            mainModal.title = "Error"
            mainModal.message = "Sadly, an error occured (MAPVIEW_RESOLV_INVALID_OBJ)"
            mainModal.enableButton = true
            mainModal.visible = true
            return;
        }
        else if (ViewsLogic.isValueAtKeyValid(currentIt, "id") && currentIt['id'] > 0)
            itineraryServices.getItinerary(currentIt['id'], function ()
            {
                return (function(statusCode, jsonStr)
                {
                    if (statusCode !== 0)
                    {
                        mainModal.title = "Error"
                        mainModal.message = "Sadly, an error occured (MAPVIEW_RESOLV_EXIST_IT_FAIL)"
                        mainModal.enableButton = true
                        mainModal.visible = true
                    }
                    updateItineraryAndDisplay()
                });
            }());
        else
            createItineraryAndDisplay();
    }
}
