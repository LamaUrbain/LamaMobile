import QtQuick 2.0
import "qrc:/Constants.js" as Constants
import "qrc:/Controls" as Controls

Rectangle
{
    property alias profilePicture: thumbnail.source
    property alias profileName: login.text
    property alias profileTitle: title.text
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height * 0.15

    Rectangle
    {
        id: thumbnailWraper
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
        radius: 10
        color: "#FFF"
        Image
        {
            id: thumbnail
            anchors.fill: parent
            anchors.margins: parent.radius / 2
        }
    }

    Rectangle
    {
        anchors.left: thumbnailWraper.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#00000000"

        Text
        {
            id: login
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Constants.fontSize
            font.bold: true
            font.pixelSize: Constants.fontSize * 2
            color: "#1A1A1A"
        }
        Text
        {
            id: title
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            //anchors.rightMargin: parent.width * 0.2
            font.pixelSize: Constants.fontSize
            color: "#333"
        }

        Controls.SettingsButton
        {
            height: parent.height * 0.4
            width: height

            anchors.top: parent.top
            anchors.right: parent.right

            onSettingsButtonPressed:
            {
                mainView.navigateToProfileSettings()
            }
        }
    }
}
