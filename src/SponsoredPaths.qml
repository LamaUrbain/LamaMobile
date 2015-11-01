import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Components.Background {
    id: rootBackground

    Components.Header {
        id: header
        title: "Sponsored paths"
    }

    ListModel {
        id: sponsorsModel

        Component.onCompleted:
        {
            ViewsLogic.fillSponsors(this, rootView.lamaSession.KNOWN_SPONSORS)
        }
    }

    Component {
        id: sponsorDelegate

        Controls.Button {
            width: sponsorGrid.width
            height: sponsorGrid.height * 0.10

            Components.SponsorItem {
                anchors.fill: parent

                sponsorToDisplay: sponsor
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    itineraryServices.getItineraries("", sponsor.username, "true", "",
                    function (status, response)
                    {
                        console.log(response)
                        rootView.mainViewTo("FavoriteItineraries", {itineraries: JSON.parse(response), readOnly: true})
                    })
                }
            }
        }
    }

    ListView {
        id: sponsorGrid

        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        model: sponsorsModel
        delegate: sponsorDelegate
    }
}
