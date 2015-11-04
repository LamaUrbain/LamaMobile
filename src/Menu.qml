import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Components.Background {

    Components.Header {
        id: header
        title: "Menu"
    }

    Column {
        id: options
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.89
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
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
            navigationTargetProperties: {'itineraries': rootView.lamaSession.KNOWN_ITINERARIES}
        }

        Controls.NavigationButton {
            id: transportPref
            centerText: "Sponsored paths"
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 4
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
            navigationTarget: "SponsoredPaths"
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
            centerText: rootView.lamaSession.IS_LOGGED ? "Your account" : "Account registration"
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 4
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
            navigationTarget: rootView.lamaSession.IS_LOGGED ? "UserAccount" : "UserRegistration"
        }
    }
}
