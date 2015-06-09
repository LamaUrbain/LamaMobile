import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

import QtLocation 5.3
import QtPositioning 5.2

Components.Marker {
    id: background
    anchors.fill: parent
    color: "transparent"

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

        zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2

        gesture.flickDeceleration: 3000
        gesture.enabled: true

        plugin: Plugin {
            name: "osm"
        }

        property GeocodeModel geocodeModel: GeocodeModel {
            plugin: map.plugin
        }

        anchors.fill: parent

        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.005
    }
}
