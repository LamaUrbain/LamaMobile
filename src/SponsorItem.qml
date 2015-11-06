import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Item {
    width: 220
    height: 252

    property alias username: sponsorName.text
    property alias email: sponsorGravatar.email

    signal selectionRequest();

    Column {
        id: itemContent
        anchors.centerIn: parent
        spacing: 8

        Controls.ImageGravatar {
            id: sponsorGravatar
            anchors.horizontalCenter: parent.horizontalCenter
            pixelSize: 200
        }

        Components.TextLabel {
            id: sponsorName
            width: sponsorGravatar.width
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: selectionRequest();
    }
}
