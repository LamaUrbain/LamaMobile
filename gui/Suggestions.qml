import QtQuick 2.0
import QtQuick.Controls 1.3
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Components.Background {
    id: waypointSuggestions
    property string waypointData

    Binding {
        target: searchTextField
        property: "placeholderText"
        value: waypointData
    }

    Components.Header {
        id: header
        title: "Suggestions of places"
    }

    Column {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.8
        spacing: 2
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Components.TextField {
            id: searchTextField
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.1
            onAccepted: {
                console.log(waypointModel)
                console.log(waypointIndex)
                console.log(waypointSuggestions.waypointModel)
                console.log(waypointSuggestions.waypointIndex)
                waypointModel.setProperty(waypointIndex, {"waypointData": searchTextField.text})
            }
        }

        Column {
            id: choices
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.55

            Components.Marker {
                id: suggestions
                centerText: "Suggestions"
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height * 0.33
            }

            Components.Marker {
                id: favorites
                centerText: "Favorites"
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.33
            }

            Components.Marker {
                id: history
                centerText: "History"
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.33
            }
        }
    }

    Components.BottomAction {
        Controls.Button {
            centerText: "Validate"
            anchors.fill: parent
            onClicked: {
                rootView.mainViewBack();
            }
        }
    }
}
