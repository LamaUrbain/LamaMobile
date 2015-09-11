import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {

    Components.Header {
        id: header
        title: "Favorites"
    }

    function refreshFavorites()
    {
        var routesCount = ViewsLogic.fillFavorites(favoriteModel, rootView.lamaSession.KNOWN_ITINERARIES);
        noFavContainer.visible = routesCount === 0;
    }

    ListModel {
        id: favoriteModel

        Component.onCompleted:
        {
            refreshFavorites()
            rootView.userSessionChanged.connect(refreshFavorites);
        }
        Component.onDestruction:
        {
            rootView.userSessionChanged.disconnect(refreshFavorites);
        }
    }


    ScrollView
    {
        id: favorites
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        height: parent.height * 0.8

        ListView {
            model: favoriteModel
            spacing: parent.height * 0.005
            delegate: Components.FavoriteItinerariesItem {
                anchors.left: parent.left
                anchors.right: parent.right
                height: favorites.height * 0.09
                favoriteDescription: itinerary.name
                linkedItinerary: itinerary
                onDeleted: {
                    rootView.lamaSession.KNOWN_ITINERARIES[index]["favorite"] = false
                    favoriteModel.remove(index)
                    rootView.saveSessionState(rootView.lamaSession)
                }
            }
        }
    }

    Rectangle
    {
        id: noFavContainer
        anchors.fill: parent
        anchors.top: header.bottom

        visible: false
        color: "#00000000"
        onVisibleChanged:
        {
            noFavTxt.text = rootView.lamaSession.IS_LOGGED ? "You have no favorites :(" : "You must first login in order\nto list your favorites routes";
            noFavLoginBtn.visible = !(rootView.lamaSession.IS_LOGGED)
        }

        Text
        {
            id: noFavTxt
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: Constants.LAMA_POINTSIZE
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //anchors.verticalCenterOffset: -(parent.height * 0.25)
        }

        Controls.NavigationButton {
            id: noFavLoginBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height * 0.3
            centerText: "Log in"
            navigationTarget: "UserAuth"
        }
    }
}
