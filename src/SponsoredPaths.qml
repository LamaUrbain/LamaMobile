import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/UserSession.js" as UserSession
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

        Rectangle {
            height: sponsorGrid.cellHeight
            width: sponsorGrid.cellWidth

            color: "transparent"

            Components.SponsorItem {
                anchors.fill: parent

                sponsorToDisplay: sponsor
            }
        }
    }

    Item {
        anchors.top: header.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        GridView {
            id: sponsorGrid

            anchors.fill: parent

            model: sponsorsModel
            delegate: sponsorDelegate
            cellWidth: parent.width / 3
            cellHeight: parent.height / 5

            snapMode: GridView.SnapToRow

            Component.onCompleted: {
                console.log(height, parent.height)
            }
        }
    }
}
