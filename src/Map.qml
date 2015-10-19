import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import QtPositioning 5.3
import MapControls 1.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Components.Marker {
    id: mapView

    property alias mapComponent: mapComponent

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
                onClicked:
                {
                    rootView.lamaSession.CURRENT_ITINERARY = Constants.LAMA_BASE_ITINERARY_OBJ
                }
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
                centerText: "Account"
                navigationTarget: "UserAuth"
                color: Constants.LAMA_ORANGE
            }
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true

        onUpdateTimeout: {
            console.log("Coordinate error:", positionSource.sourceError)
        }

        Component.onCompleted: {
            if (positionSource.valid)
                console.log("PositionSource is valid, coordinate will be available")
            else
                console.log("PositionSource is NOT valid, coordinate won't be available")
        }

        onPositionChanged: {
            var coord = positionSource.position.coordinate
            console.log("Coordinate:", coord.longitude, coord.latitude);
            mapCircle.coordinate.x = coord.longitude
            mapCircle.coordinate.y = coord.latitude
            mapCircle.visible = true
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
            mapPieMenu.pieCoords = coords;
            mapPieMenu.popup(pos.x, pos.y);

            var showAllButtons = isItineraryValid();
            menuSetDep.visible = showAllButtons
            menuAdd.visible = showAllButtons
            menuSetDest.visible = showAllButtons
        }

        function isItineraryValid()
        {
            return (rootView.lamaSession.CURRENT_ITINERARY != undefined
                    && rootView.lamaSession.CURRENT_ITINERARY.departure != undefined)
        }

        onMapPointMoved:
        {
            rootView.moveItineraryPoint(id, point, newCoords);
        }

        Components.MapCircle {
            id: mapCircle
            visible: false
            color: Constants.LAMA_ORANGE
            radius: 20
        }

        Components.MapPieMenu {
            id: mapPieMenu
            property point pieCoords

            width: 250
            height: 250

            MenuItem {
                id: menuSetDep
                text: "Set Departure"
                onTriggered: {
                    rootView.setDeparture(mapPieMenu.pieCoords);
                    //ViewsLogic.spawnDeparturePopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_DEPARTURE_RESSOURCE
            }
            MenuItem {
                id: menuAdd
                text: "Add Waypoint"
                onTriggered: {
                    rootView.addWaypoint(mapPieMenu.pieCoords);
                    //ViewsLogic.spawnWaypointPopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_INDICATOR_RESSOURCE
            }
            MenuItem {
                id: menuSetDest
                text: "Set Destination"
                onTriggered: {
                    rootView.setDestination(mapPieMenu.pieCoords);
                    //ViewsLogic.spawnArrivalPopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_ARRIVAL_RESSOURCE
            }
            MenuItem {
                text: "New itinerary"
                onTriggered: {
                    rootView.checkCurrentIt()
                    rootView.mainViewTo("MainSearch", null)
                }
                iconSource: Constants.LAMA_ARRIVAL_RESSOURCE
            }
        }
    }

    Component.onCompleted: {
        rootView.mapView = mapView;
    }
}
