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
            title: "Search"
        }

        Components.Marker {
            id: search
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.8
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005

            Components.Marker {
                id: start
                centerText: "Depart:"
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.79
                height: parent.height * 0.14
                anchors.topMargin: parent.height * 0.005
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: startButton
                centerText: "Modify"
                anchors.left: start.right
                anchors.top: parent.top
                width: parent.width * 0.19
                height: parent.height * 0.14
                anchors.topMargin: parent.height * 0.005
                anchors.leftMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: waypointArea
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: start.bottom
                height: parent.height * 0.7
                anchors.topMargin: parent.height * 0.005
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005

                Components.Marker {
                    id: waypoint1
                    centerText: "waypoint 1"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: parent.height * 0.2
                }

                Components.Marker {
                    id: waypoint2
                    centerText: "waypoint 2"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: waypoint1.bottom
                    height: parent.height * 0.2
                }

                Components.Marker {
                    id: addWaypointButton
                    centerText: "+"
                    anchors.right: parent.right
                    anchors.top: waypoint2.bottom
                    width: parent.height * 0.15
                    height: parent.height * 0.15
                }
            }

            Components.Marker {
                id: touristOptions
                centerText: "Tourist Options"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: arrival.top
                height: parent.height * 0.15
            }

            Components.Marker {
                id: arrival
                centerText: "Arrival"
                anchors.left: parent.left
                anchors.bottom: search.bottom
                width: parent.width * 0.8
                height: parent.height * 0.15
            }

            Components.Marker {
                id: arrivalButton
                centerText: "Modify"
                anchors.left: arrival.right
                anchors.bottom: search.bottom
                width: parent.width * 0.2
                height: parent.height * 0.15
            }
        }

        Components.BottomAction {
            id: launch
            centerText: "Launch"
        }

    }
}


