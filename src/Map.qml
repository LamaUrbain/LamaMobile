import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import MapControls 1.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

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

    MapWidget
    {
        id: mapComponent

        anchors.fill: parent
        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.005

        onMapPointClicked:
        {
            ViewsLogic.spawnPopOver(mapComponent, coords, "je suis une popup :3 !")
        }

        Controls.ImageButton {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width * (0.10 + 0.04)
            height: parent.height * (0.10 + 0.02)
            iconSource: Constants.LAMA_ADD_RESSOURCE
            onClicked:
            {
                rootView.lamaSession.CURRENT_ITINERARY = Constants.LAMA_BASE_ITINERARY_OBJ
                rootView.mainViewTo("MainSearch", null)
            }
        }
    }

    function proceedToAddWayPoints(itineraryId, wayPointsArray, rootView, displayCallback)
    {
        var wayPointCount = wayPointsArray.length; // Fucking flies because of dereferencement

        if (wayPointCount === 0)
        {
            try {
            displayCallback(parseInt(rootView.lamaSession.CURRENT_ITINERARY['id']));
            } catch (e) { console.log(e) }
            rootView.modal.visible = false;
        }
        else
        {
            for (var idx = 0; idx < wayPointCount; ++idx)
            {
                itineraryServices.addDestination(itineraryId, wayPointsArray[idx], idx,
                                                 function (rootView, mapComponent, idx)
                {
                    return (function(statusCode, jsonStr)
                    {
                        if (statusCode !== 0)
                        {
                            rootView.modal.title = "Error"
                            rootView.modal.text = "Sadly, an error occured (MAPVIEW_RESOLV_DEST_ADD_FAIL)"
                            rootView.modal.enableButton = true
                            rootView.modal.visible = true
                        }

                        if (idx + 1 === wayPointCount)
                            displayCallback(jsonObj["id"]);
                    });
                }(rootView, mapComponent, idx));
            }
        }
    }

    function updateItineraryAndDisplay()
    {
        console.log("TODO updateItinerary")

        mapView.mapComponent.displayItinerary(jsonObj["id"]);
    }

    function createItineraryAndDisplay()
    {
        var currentIt = rootView.lamaSession.CURRENT_ITINERARY
        var startPoint = currentIt["departure"]
        var lastId = currentIt["destinations"].length - 1
        var arrivalPoint = currentIt["destinations"][lastId]
        var requestDeparture = startPoint["longitude"] + ', ' + startPoint["latitude"]
        var requestArrival = arrivalPoint["longitude"] + ', ' + arrivalPoint["latitude"]

        var waypointArray = [];
        if (lastId !== 0)
            for (var idx = 0; idx < lastId; ++idx)
            {
                var currentPoint = currentIt["destinations"][idx]
                waypointArray.push(currentPoint["longitude"] + ', ' + currentPoint["latitude"])
            }

        if (currentIt['name'] === null || currentIt['name'] === '')
            currentIt['name'] = "tmp_itinerary_" + ViewsLogic.getRandomString(8);

        //itineraryServices.abortPendingRequests()
        itineraryServices.createItinerary(currentIt['name'], requestDeparture, requestArrival, currentIt["favorite"] ? "true" : "false",
                        function(rootView1, nextCallBack, displayCallback, waypointArray)
        {
            return (function(statusCode, jsonStr)
            {
                console.log("CreateItinerary Response Status : " + statusCode);
                if (statusCode === 0)
                {
                    var jsonObj = JSON.parse(jsonStr)
                    var ItId = jsonObj["id"]
                    console.log("CreateItinerary Response Id : " + ItId);
                    rootView1.lamaSession.CURRENT_ITINERARY['id'] = ItId;
                    nextCallBack(ItId, waypointArray, rootView1, displayCallback)
                }
                else
                {
                    rootView1.Modal.title = "Error"
                    rootView1.Modal.message = "Unfortunatly the llama did not find his way"
                    rootView1.Modal.enableButton = true
                    rootView1.Modal.setLoadingState(false)
                }
            });
        }(rootView, proceedToAddWayPoints, mapComponent.displayItinerary, waypointArray));
    }

    function resolveCurrentItinerary()
    {
        mainModal.title = "Resolving itinierary"
        mainModal.setLoadingState(true)
        mainModal.enableButton = false
        mainModal.visible = true

        var currentIt = rootView.lamaSession.CURRENT_ITINERARY;

        if (!ViewsLogic.isValueAtKeyValid(currentIt, "departure")
                || !ViewsLogic.isValueAtKeyValid(currentIt, "destinations"))
        {
            mainModal.title = "Error"
            mainModal.text = "Sadly, an error occured (MAPVIEW_RESOLV_INVALID_OBJ)"
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
                        mainModal.text = "Sadly, an error occured (MAPVIEW_RESOLV_EXIST_IT_FAIL)"
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
