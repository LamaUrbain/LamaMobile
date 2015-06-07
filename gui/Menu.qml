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
            title: "Menu"
        }

        Components.Marker {
            id: options
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.89
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Column {
                anchors.fill: parent
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005

                Controls.NavigationButton {
                    id: favoriteRoutes
                    centerText: "Favorite routes"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 4
                    anchors.leftMargin: parent.height * 0.005
                    anchors.rightMargin: parent.height * 0.005
                    anchors.topMargin: parent.height * 0.005
                    anchors.bottomMargin: parent.height * 0.005
                    navigationTarget: "FavoriteItineraries"
                }

                Controls.NavigationButton {
                    id: transportPref
                    centerText: "Transport Preferences"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 4
                    anchors.leftMargin: parent.height * 0.005
                    anchors.rightMargin: parent.height * 0.005
                    anchors.topMargin: parent.height * 0.005
                    anchors.bottomMargin: parent.height * 0.005
                    navigationTarget: "TransportPreferences"
                }

                Controls.NavigationButton {
                    id: feedback
                    centerText: "User Feedback"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 4
                    anchors.leftMargin: parent.height * 0.005
                    anchors.rightMargin: parent.height * 0.005
                    anchors.topMargin: parent.height * 0.005
                    anchors.bottomMargin: parent.height * 0.005
                    navigationTarget: "UserFeedback"
                }

                Controls.NavigationButton {
                    id: account
                    centerText: "User account"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 4
                    anchors.leftMargin: parent.height * 0.005
                    anchors.rightMargin: parent.height * 0.005
                    anchors.topMargin: parent.height * 0.005
                    anchors.bottomMargin: parent.height * 0.005
                    navigationTarget:  "UserAccount"
                }
            }
        }
    }
}
