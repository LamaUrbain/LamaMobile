import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
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
                    rootView.lamaSession.LAMA_USER_CURRENT_ITINERARY = Constants.LAMA_BASE_ITINERARY_OBJ
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
            mapPieMenu.pieCoords = coords;
            mapPieMenu.popup(pos.x, pos.y);
        }
        onMapPointMoved:
        {
            rootView.moveItineraryPoint(id, point, newCoords);
        }

        Components.MapPieMenu {
            id: mapPieMenu
            property point pieCoords

            scale: 1.2

            MenuItem {
                text: "Set Departure"
                onTriggered: {
                    ViewsLogic.spawnDeparturePopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_DEPARTURE_RESSOURCE
            }
            MenuItem {
                text: "Add Waypoint"
                onTriggered: {
                    ViewsLogic.spawnWaypointPopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_INDICATOR_RESSOURCE
            }
            MenuItem {
                text: "Set Destination"
                onTriggered: {
                    ViewsLogic.spawnArrivalPopOver(mapComponent, mapPieMenu.pieCoords, "je suis une popup :3 !");
                }
                iconSource: Constants.LAMA_ARRIVAL_RESSOURCE
            }
        }
    }

    Component.onCompleted: {
        rootView.mapView = mapView;
    }
}
