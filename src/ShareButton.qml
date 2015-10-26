import QtQuick 2.0
import QtQuick.Layouts 1.2
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls/" as Controls

IconButton
{
    property var itinerary

    id: shareButton
    text: "Share"
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    height: parent.height
    iconSource: Constants.LAMA_SHARE_RESSOURCE

    Component {
        id: shareComponent

        Rectangle
        {
            anchors.fill: parent;
            color: "#00000000"

            Text {
                text: "Share this itinerary on :"
                color: Constants.LAMA_YELLOW
                font.pixelSize: Constants.LAMA_POINTSIZE
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
            }

            Controls.NavigationButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.6
                anchors.rightMargin: parent.width * 0.1
                height: parent.height * 0.35

                centerText: "Facebook"
                navigationTarget: "WebView"
                navigationTargetProperties: {
                    var properties = { webUrl: Constants.LAMA_URL_FACEBOOK_SHARE + itinerary['id'] }
                    return (properties);
                }
            }

            Controls.NavigationButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.6
                anchors.leftMargin: parent.width * 0.1
                height: parent.height * 0.35

                centerText: "Twitter"
                navigationTarget: "WebView"
                navigationTargetProperties:
                {
                    var properties = { webUrl: Constants.LAMA_URL_TWITTER_SHARE + itinerary['id'] + Constants.LAMA_URL_TWITTER_HASHTAGS }
                    return (properties);
                }
            }
        }

    }

    onClicked: {
        mainModal.buttonText = "Cancel"
        ViewsLogic.spawnModalWithSource("Share", shareComponent)
    }
}
