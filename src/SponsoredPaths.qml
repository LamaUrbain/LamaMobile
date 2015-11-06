import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    color: Constants.LAMA_BACKGROUND2

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: "Our sponsors"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                clip: true
                width: Math.min(Math.floor(parent.width / cellWidth), model.count) * cellWidth
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                cellWidth: 220
                cellHeight: 252
                model: rootView.sponsors
                delegate: Components.SponsorItem {
                    username: model.username
                    email: model.email
                    onSelectionRequest: {
                        rootView.mainViewTo("FavoriteItineraries", null, { owner: username });
                    }
                }
            }
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Controls.NavigationButton {
            anchors.left: parent.left
            anchors.right: parent.right
            source: Constants.LAMA_SPONSORS_RESSOURCE
            text: "Become a sponsor!"
            acceptClick: false
            onNavButtonPressed: Qt.openUrlExternally("http://eip.epitech.eu/2016/lamaurbain/#contact");
        }
    }
}
