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
            title: "Suggestions of places"
        }

        Components.Marker {
            id: searchLabel
            centerText: "Road of a..."
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

        }

        Components.Marker {
            id: choices
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: searchLabel.bottom
            height: parent.height * 0.55
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.Marker {
                id: suggestions
                centerText: "Suggestions"
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height * 0.33
            }

            Components.Marker {
                id: favorites
                centerText: "Favorites"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: suggestions.bottom
                height: parent.height * 0.33
            }

            Components.Marker {
                id: history
                centerText: "History"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: favorites.bottom
                height: parent.height * 0.33
            }
        }

        Components.Marker {
            id: keyboard
            centerText: "Keyboard"
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: choices.bottom
            anchors.bottomMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.leftMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            height: parent.height * 0.23
        }
    }
}
