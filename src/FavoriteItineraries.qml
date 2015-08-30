import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {

    Components.Header {
        id: header
        title: "Favorites"
    }

    function refreshFavorites()
    {
        ViewsLogic.fillFavorites(favoriteModel, rootView.lamaSession.KNOWN_ITINERARIES);
    }

    ListModel {
        id: favoriteModel

        Component.onCompleted:
        {
            ViewsLogic.fillFavorites(this, rootView.lamaSession.KNOWN_ITINERARIES)
            rootView.userSessionChanged.connect(refreshFavorites);
        }
        Component.onDestruction:
        {
            rootView.userSessionChanged.disconnect(refreshFavorites);
        }
    }


    ScrollView {
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
                    favoriteModel.remove(index)
                    rootView.lamaSession.KNOWN_ITINERARIES[index]["favorite"] = false
                    UserSession.saveSessionState(rootView.lamaSession)
                }
            }
        }
    }
}
