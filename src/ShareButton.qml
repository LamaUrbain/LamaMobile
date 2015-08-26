import QtQuick 2.0
import QtQuick.Layouts 1.2
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components

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
        ColumnLayout {
            anchors.fill: parent

            anchors.leftMargin: parent.width * 0.005
            anchors.rightMargin: parent.width * 0.005

            Components.TextField {
                id: pouet

                anchors.left: parent.left
                anchors.right: parent.right

                anchors.leftMargin: parent.width * 0.01
                anchors.rightMargin: parent.width * 0.01

                Layout.preferredHeight: parent.height * 0.1
                placeholderText:"http://api.lama/share/" + encodeURIComponent(itinerary["owner"]) + "/" + encodeURIComponent(itinerary["name"])
                readOnly: true
                Component.onCompleted: {
                    selectAll()
                }
            }

            Row
            {
                anchors.leftMargin: parent.width * 0.005
                anchors.rightMargin: parent.width * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005

                Layout.preferredHeight: parent.height * 0.20

                anchors.horizontalCenter: parent.horizontalCenter

                spacing: parent.height * 0.025

                Components.Marker {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    centerText: "FACEBOOK"
                }

                Components.Marker {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    centerText: "TWITTER"
                }
            }

        }
    }

    onClicked: {
        ViewsLogic.spawnModalWithSource("Share", shareComponent)
    }
}
