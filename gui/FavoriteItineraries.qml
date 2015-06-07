import QtQuick 2.0
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Rectangle {

    Components.Marker {
        id: background
        anchors.fill: parent

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
                    centerText: "Favorite " + index
                }
            }
        }

        Components.BottomAction {
            id: footer

            RowLayout {
                anchors.fill: parent
                spacing: 2

                Controls.Button {
                    id: shareButton
                    Layout.fillWidth: true
                    centerText: "Share"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    height: parent.height
                }

                Controls.Button {
                    id: modifyButton
                    Layout.fillWidth: true
                    centerText: "Edit"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    height: parent.height
                }

                Controls.Button {
                    id: deleteButton
                    Layout.fillWidth: true
                    centerText: "Delete"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
