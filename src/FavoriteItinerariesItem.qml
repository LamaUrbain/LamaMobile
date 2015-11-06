import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

MouseArea {
    id: favoriteItem
    height: contents.height
    onClicked: displayRequest();

    property alias name: favoriteText.text
    property int itineraryId: -1
    property bool readOnly: false

    signal displayRequest();
    signal deleteRequest();

    Column {
        id: contents
        spacing: 12
        anchors {
            left: parent.left
            right: parent.right
        }

        Components.TextLabel {
            id: favoriteText
            elide: Text.ElideRight
            anchors {
                left: parent.left
                right: parent.right
                rightMargin: 120
            }
        }

        RowLayout {
            spacing: 8
            anchors {
                left: parent.left
                right: parent.right
                rightMargin: 120
            }

            Controls.Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                source: Constants.LAMA_SEE_RESSOURCE
                onClicked: favoriteItem.displayRequest();
            }

            Controls.DeleteButton {
                visible: !readOnly
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                onDeleted: favoriteItem.deleteRequest();
            }

            Controls.FacebookButton {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                itineraryId: favoriteItem.itineraryId
            }

            Controls.TwitterButton {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                itineraryId: favoriteItem.itineraryId
            }
        }

        Components.Separator {
            height: 11
            isTopSeparator: true
            anchors {
                left: parent.left
                right: parent.right
            }
        }
    }

    Image {
        width: 28
        height: 48
        opacity: 0.5
        source: Constants.LAMA_ARROW_RESSOURCE
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }
}
