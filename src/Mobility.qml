import QtQuick 2.0
import QtQuick.Controls 1.2
import MobilityDiagram 1.0
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

            Rectangle
            {
                id: mobilitySettings
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.3
            }

            MobilityDiagram
            {
                anchors.margins: parent.width * 0.06
                anchors.top: mobilitySettings.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
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

