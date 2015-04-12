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

            TextField
            {
                id: emailField
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: parent.width * 0.05
                anchors.rightMargin: anchors.leftMargin
                anchors.topMargin: parent.height * 0.05
                font.pixelSize: Constants.fontSize
                placeholderText: "Email de contact"
            }

            Text
            {
                id: feedBackText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: emailField.bottom
                anchors.leftMargin: parent.width * 0.05
                anchors.rightMargin: anchors.leftMargin
                anchors.topMargin: parent.height * 0.025
                text: "Décrivez nous vos impressions:"
                font.pixelSize: Constants.fontSize
            }

            TextArea
            {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: feedBackText.bottom
                anchors.bottom: submitFeedBackBtn.top
                anchors.topMargin: parent.height * 0.025
                anchors.bottomMargin: anchors.topMargin
                anchors.leftMargin: parent.width * 0.05
                anchors.rightMargin: anchors.leftMargin

                font.pixelSize: Constants.fontSize
            }

            Button
            {
                id: submitFeedBackBtn
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: parent.width * 0.05
                text: "Envoyer"
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

