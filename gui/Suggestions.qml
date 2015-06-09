import QtQuick 2.0
import QtQuick.Controls 1.3
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Rectangle {
    id: waypointSuggestions
    property ListModel waypointModel
    property int waypointIndex

    Component.onCompleted: {
        var elem = waypointModel.get(waypointIndex)
        searchTextField.text = elem.waypointData
    }

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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
            TextField {
                id: searchTextField
                anchors.fill: parent
                opacity: 0.9
                onAccepted: {
                    console.log(waypointModel)
                    console.log(waypointIndex)
                    console.log(waypointSuggestions.waypointModel)
                    console.log(waypointSuggestions.waypointIndex)
                    waypointModel.setProperty(waypointIndex, {"waypointData": searchTextField.text})
                }
            }
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

        Components.BottomAction {
            Controls.NavigationButton {
                anchors.fill: parent
                navigationTarget: "MainSearch"
            }
        }
    }
}
