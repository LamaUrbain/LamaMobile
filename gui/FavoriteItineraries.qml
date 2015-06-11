import QtQuick 2.0
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Components.Background {

    Components.Header {
        id: header
        title: "Favorites"
    }

    Column {
        id: itineraries
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.8
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Repeater {
            model: 2
            Components.FavoriteItinerariesItem {
                anchors.left: parent.left
                anchors.right: parent.right
                favoriteDescription: "Favorite " + index
                height: parent.height * 0.10
            }
        }
    }
}
