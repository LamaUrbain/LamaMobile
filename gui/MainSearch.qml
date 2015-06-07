import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

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

            Components.Waypoint {
                id: start
                placeholderText: "Depart:"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height * 0.14
                anchors.topMargin: parent.height * 0.005
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
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

                Column {
                    id: waypoints
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height * 0.85

                    Components.Waypoint {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        deletable: true
                        height: parent.height * 0.2
                    }

                    Components.Waypoint {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        deletable: true
                        height: parent.height * 0.2
                    }
                }

                Components.Marker {
                    id: addWaypointButton
                    centerText: "+"
                    anchors.right: parent.right
                    anchors.top: waypoints.bottom
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

            Components.Waypoint {
                id: arrival
                placeholderText: "Arrival"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: search.bottom
                width: parent.width * 0.8
                height: parent.height * 0.15
            }
        }

        Components.BottomAction {
            id: launch
            Controls.Button {
                anchors.fill: parent
                centerText: "Launch"
            }
        }

    }
}


