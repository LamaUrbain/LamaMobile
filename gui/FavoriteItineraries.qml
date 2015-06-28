import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Components.Background {

    Components.Header {
        id: header
        title: "Favorites"
    }

    ListModel {
        id: favoriteModel

        ListElement {
            favName: "To School"
        }
        ListElement {
            favName: "To Home"
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
                favoriteDescription: favName
                onDeleted: {
                    favoriteModel.remove(index)
                }
            }
        }
    }
}
