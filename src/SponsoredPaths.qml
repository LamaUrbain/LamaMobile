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
        title: "Sponsored paths"
    }

    ListModel {
        id: sponsorsModel

        Component.onCompleted:
        {
            ViewsLogic.fillSponsors(this, UserSession.LAMA_USER_KNOWN_SPONSORS)
        }
    }

    ScrollView {
        id: sponsors
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005
        height: parent.height * 0.8

        ListView {
            model: sponsorsModel
            spacing: parent.height * 0.005
            delegate: Components.SponsorItem {
                anchors.left: parent.left
                anchors.right: parent.right
                height: sponsors.height * 0.09
                sponsorDescription: sponsor.name
                onDeleted: {
                    sponsorsModel.remove(index)
                }
            }
        }
    }
}
