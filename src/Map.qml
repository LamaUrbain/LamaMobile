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
        onMapPointMoved:
        {
            rootView.moveItineraryPoint(id, point, newCoords);
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

    Component.onCompleted: {
        rootView.mapView = mapView;
    }
}
