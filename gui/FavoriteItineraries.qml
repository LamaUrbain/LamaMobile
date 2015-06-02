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
            title: "Favorites"
        }

        Components.Marker {
            id: itineraries
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.8
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.FavoriteItinerariesItem {
                id: favorite0
                centerText: "Favorite 0"
            }

            Components.FavoriteItinerariesItem {
                id: favorite1
                centerText: "Favorite 1"
            }
        }

        Components.BottomAction {
            id: footer

            Components.Marker {
                id: modifyButton
                centerText: "Edit"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.5
                height: parent.height
            }

            Components.Marker {
                id: deleteButton
                centerText: "Delete"
                anchors.right: parent.right
                anchors.top: parent.top
                width: parent.width * 0.5
                anchors.bottom: parent.bottom
            }
        }

    }
}
