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

            Grid {
                anchors.fill: parent
                columns: 2
                rows: 3

                Controls.TransportCheckedBox {
                    iconName: "bus"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }

                Controls.TransportCheckedBox {
                    iconName: "tramway"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }

                Controls.TransportCheckedBox {
                    iconName: "onfoot"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }

                Controls.TransportCheckedBox {
                    iconName: "bike"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }

                Controls.TransportCheckedBox {
                    iconName: "vehicle"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }

                Controls.TransportCheckedBox {
                    iconName: "train"
                    width: parent.width * 0.5
                    height: parent.height * 0.33
                }
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
            Controls.NavigationButton {
                anchors.fill: parent
                centerText: "Save parameters"
                navigationTarget: "Map"
            }
        }
    }
}


