import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession

RowLayout {
    property alias sponsorName: sponsorName.text
    property alias sponsorLogoUrl: sponsorLogo.source

    signal deleted()

    function raiseDeleted()
    {
        deleted()
    }

    Image
    {
        id: sponsorLogo
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.15

            color: "black"
            opacity: 0.8
            z: 1

            Text
            {
                id: sponsorName
                anchors.centerIn: parent
                color: Constants.LAMA_YELLOW
                font.pointSize: Constants.LAMA_POINTSIZE
                opacity: 1
                z:2
            }
        }
    }
}
