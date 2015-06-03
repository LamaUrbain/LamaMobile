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

            Components.Marker {
                id: favoriteRoutes
                centerText: "Favorite routes"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height * 0.245
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("FavoriteItineraries")
                }
            }

            Components.Marker {
                id: transportPref
                centerText: "Transport Preferences"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: favoriteRoutes.bottom
                height: parent.height * 0.245
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("TransportPreferences")
                }
            }

            Components.Marker {
                id: feedback
                centerText: "User Feedback"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: transportPref.bottom
                height: parent.height * 0.245
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("UserFeedback")
                }
            }

            Components.Marker {
                id: account
                centerText: "User account"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: feedback.bottom
                height: parent.height * 0.24
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("UserAccount")
                }
            }
        }
    }
}
