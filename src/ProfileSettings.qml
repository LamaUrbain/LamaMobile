import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "ViewsLogic.js" as ViewsLogic
import "ViewsData.js" as ViewsData

Rectangle
{
    Rectangle
    {
        id: viewContent
        color: "#AAA"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: commandBar.top

        Components.MenuHeader
        {
            color: "#AAA"
            id: header
            profilePicture: ViewsData.profilePicture
            profileName: ViewsData.profileName
            profileTitle: ViewsData.profileTitle
            anchors.margins: 10
            showSettingsButton: false
        }

        Rectangle
        {
            id: menuContent
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            radius: 10
            anchors.margins: 10

            Column
            {
                anchors.margins: 20
                anchors.fill: parent
                spacing: 15
                Text
                {
                    font.pixelSize: Constants.fontSize
                    font.bold: true
                    text: "Identifiant de compte:"
                }
                TextField
                {
                    id: loginField
                    font.pixelSize: Constants.fontSize
                    textColor: "#000"
                    width: menuContent.width * 0.9
                }
                Text
                {
                    font.pixelSize: Constants.fontSize
                    font.bold: true
                    text: "Mot de passe:"
                }
                TextField
                {
                    id: passwordField
                    font.pixelSize: Constants.fontSize
                    textColor: "#000"
                    width: menuContent.width * 0.9
                }
                Button
                {
                    text: "Authentification"
                    onClicked:
                    {
                        ViewsData.profileName = loginField.text
                    }
                }
            }
        }
    }

    Components.CommandBar
    {
        id: commandBar

        Controls.ReturnButton
        {
            onReturnButtonPressed:
            {
                mainView.navigateBack()
            }

            width: parent.width * 0.1
            anchors.rightMargin: width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}

