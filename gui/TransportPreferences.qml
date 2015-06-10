import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {

    Components.Header {
        id: header
        title: "Transport Preferences"
    }

    Grid {
        id: transportSelection
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.3
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        columns: 2
        rows: 3

        Controls.TransportCheckedBox {
            iconName: "Bus"
            iconAsset: Constants.LAMA_BUS_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }

        Controls.TransportCheckedBox {
            iconName: "Tramway"
            iconAsset: Constants.LAMA_TRAM_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }

        Controls.TransportCheckedBox {
            iconName: "On Foot"
            iconAsset: Constants.LAMA_ONFOOT_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }

        Controls.TransportCheckedBox {
            iconName: "Bike"
            iconAsset: Constants.LAMA_BIKE_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }

        Controls.TransportCheckedBox {
            iconName: "Car"
            iconAsset: Constants.LAMA_CAR_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }

        Controls.TransportCheckedBox {
            iconName: "train"
            iconAsset: Constants.LAMA_TRAIN_RESSOURCE
            width: parent.width * 0.5
            height: parent.height * 0.33
        }
    }

    Components.Marker {
        id: diagramArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: transportSelection.bottom
        height: parent.height * 0.5
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        centerText: "Diagram"
    }

    Components.BottomAction {
        Controls.NavigationButton {
            anchors.fill: parent
            centerText: "Save parameters"
            navigationTarget: "Map"
        }
    }
}


