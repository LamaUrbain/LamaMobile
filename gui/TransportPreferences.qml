import QtQuick 2.0
import "qrc:/Components/" as Components

Rectangle {

    Components.Marker {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Components.Header {
            id: header
            title: "Transport Preferences"
        }

        Components.Marker {
            id: transportSelection
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.3
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            // Left side
            Components.Marker {
                id: bus
                centerText: "Bus Selection"
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: metro
                centerText: "Metro Selection"
                anchors.left: parent.left
                anchors.top: bus.bottom
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: pedestrian
                centerText: "Pedestrian Selection"
                anchors.left: parent.left
                anchors.top: metro.bottom
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            // Right side
            Components.Marker {
                id: bicycle
                centerText: "Bicycle Selection"
                anchors.right: parent.right
                anchors.top: parent.top
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: car
                centerText: "Car Selection"
                anchors.right: parent.right
                anchors.top: bicycle.bottom
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: train
                centerText: "Train Selection"
                anchors.right: parent.right
                anchors.top: car.bottom
                width: parent.width * 0.5
                height: parent.height * 0.33
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
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

            Components.Marker {
                id: diagram
                centerText: "Diagram"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height
            }
        }

        Components.BottomAction {
            id: saveButton
            centerText: "Save parameters"
        }
    }
}


