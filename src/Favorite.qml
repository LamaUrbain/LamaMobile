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

            Rectangle
            {
                id: favoritesTitle
                height: Constants.fontSize * 2
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Constants.fontSize

                Image
                {
                    id: favoriteIcon
                    source: "qrc:/Assets/Images/favoriteIcon.png"
                    height: parent.height
                    width: height
                }

                Text
                {
                    anchors.left: favoriteIcon.right
                    anchors.leftMargin: parent.width * 0.1
                    text: "Itinéraires favoris"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Constants.fontSize
                }
            }

            ScrollView
            {
                anchors.top: favoritesTitle.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 30

                ListView
                {
                    id: favoritesList
                    model: ListModel { id: favoritesListModel }
                    Component.onCompleted: { ViewsLogic.fillFavoriteLocations(favoritesListModel) }
                    delegate:
                    Column
                    {
                        Text
                        {
                            text: address
                            font.pixelSize: Constants.fontSize
                        }
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

