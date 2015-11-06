import QtQuick 2.0
import QtQuick.Layouts 1.2
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls/" as Controls

NavigationButton {
    id: shareButton
    text: "Share"
    source: Constants.LAMA_SHARE_RESSOURCE

    property int itineraryId: -1

    Component {
        id: shareComponent

        RowLayout {
            spacing: 25

            Controls.FacebookButton {
                Layout.fillWidth: true
                itineraryId: shareButton.itineraryId
            }

            Controls.TwitterButton {
                Layout.fillWidth: true
                itineraryId: shareButton.itineraryId
            }
        }
    }

    onClicked: {
        mainModal.title = "Share";
        mainModal.modalSourceComponent = shareComponent;
        mainModal.loading = false;
        mainModal.visible = true;
    }
}
