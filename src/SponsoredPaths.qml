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
            ViewsLogic.fillSponsors(this, UserSession.LAMA_USER_KNOWN_SPONSORS)
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

                sponsorName: sponsor.name
                sponsorLogoUrl: sponsor.logo
            }
        }
    }

    GridView {
        id: sponsorGrid
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.005
        anchors.topMargin: parent.height* 0.005
        anchors.bottomMargin: parent.height* 0.005

        height: parent.height * 0.9

        model: sponsorsModel
        delegate: sponsorDelegate
        cellWidth: parent.width * 1/3
        cellHeight: parent.height * 1/5
    }
}
