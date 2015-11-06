import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    id: favoritesView
    color: Constants.LAMA_BACKGROUND2

    property string owner: rootView.session.username
    property bool readOnly: owner != "" && owner != rootView.session.username

    Component.onCompleted: {
        reloadFavorites();
    }

    function reloadFavorites()
    {
        favoriteModel.clear();
        if (owner)
        {
            rootView.loadFavorites(owner, function(obj)
            {
                for (var i = 0; i < obj.length; ++i)
                    favoriteModel.append(obj[i]);
            });
        }
    }

    ListModel { id: favoriteModel }

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: favoritesView.readOnly ? favoritesView.owner : "Your favorites"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        ListView {
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: favoriteModel
            spacing: 8
            delegate: Components.FavoriteItinerariesItem {
                anchors.left: parent.left
                anchors.right: parent.right
                name: model.name
                readOnly: favoritesView.readOnly
                itineraryId: model.id
                onDeleteRequest: rootView.deleteItinerary(model.id, reloadFavorites);
                onDisplayRequest: {
                    rootView.displayItinerary(model.id);
                    rootView.mainViewTo("Map", false, null);
                }
            }
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 15
            anchors {
                left: parent.left
                right: parent.right
            }

            Controls.NavigationButton {
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_PROFILE_RESSOURCE
                text: "Your profile"
                navigationTarget: "UserProfile"
                visible: !favoritesView.readOnly
            }

            Controls.NavigationButton {
                text: "Your settings"
                primary: false
                source: Constants.LAMA_SETTINGS_RESSOURCE
                anchors.left: parent.left
                anchors.right: parent.right
                navigationTarget: "UserAccount"
                visible: !favoritesView.readOnly
            }

            Controls.NavigationButton {
                text: "Back to sponsors"
                source: Constants.LAMA_BACK_RESSOURSE
                anchors.left: parent.left
                anchors.right: parent.right
                acceptClick: false
                onNavButtonPressed: rootView.mainViewBack();
                visible: favoritesView.readOnly
            }
        }
    }
}
