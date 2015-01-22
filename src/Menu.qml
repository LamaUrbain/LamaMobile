import QtQuick 2.0
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "ViewsLogic.js" as ViewsLogic
import "ViewsData.js" as ViewsData

Rectangle {
    id: mainContent
    anchors.fill: parent

    Rectangle
    {
        id: viewContent
        color: "#AAA"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: commandbar.top

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
                anchors.fill: parent
                anchors.margins: 10

                Components.MenuSection
                {
                    id: settings
                    sectionTitle: "Préfèrences"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: parent.height * (2/9)
                    onMenuItemClicked:
                    {
                        mainView.navigateFromMenu(qmlFileName)
                    }

                    menuItemsModel:
                        ListModel
                        {
                            ListElement
                            {
                                menuItemName: "Itinéraires favoris"
                                menuItemKey: "Favorite"
                            }
                            ListElement
                            {
                                menuItemName: "Moyens de transport"
                                menuItemKey: "Mobility"
                            }
                        }
                }

                Components.MenuSection
                {
                    id: general
                    sectionTitle: "Général"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: settings.bottom
                    height: parent.height * (4/9)
                    onMenuItemClicked:
                    {
                        mainView.navigateFromMenu(qmlFileName)
                    }

                    menuItemsModel:
                        ListModel
                        {
                            ListElement
                            {
                                menuItemName: "Alertes"
                                menuItemKey: "Alert"
                            }
                            ListElement
                            {
                                menuItemName: "Easter planet"
                                menuItemKey: "Report"
                            }
                            ListElement
                            {
                                menuItemName: "Contributions"
                                menuItemKey: "Contribute"
                            }
                            ListElement
                            {
                                menuItemName: "Feedback utilisateur"
                                menuItemKey: "Feedback"
                            }
                        }
                }

                Components.MenuSection
                {
                    id: about
                    sectionTitle: "Lama Urbain"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: general.bottom
                    height: parent.height * (3/9)
                    onMenuItemClicked:
                    {
                        mainView.navigateFromMenu(qmlFileName)
                    }

                    menuItemsModel:
                        ListModel
                        {
                            ListElement
                            {
                                menuItemName: "Actualités"
                                menuItemKey: "News"
                            }
                            ListElement
                            {
                                menuItemName: "Rapport de plantage"
                                menuItemKey: "Report"
                            }
                            ListElement
                            {
                                menuItemName: "Aide"
                                menuItemKey: "Help"
                            }
                        }
                }
            }
        }

    }

    Components.CommandBar
    {
        id: commandbar

        Controls.MapButton
        {
            onMapButtonPressed:
            {
                mainView.navigateToMap(null, null)
            }

            width: parent.width * 0.1
            anchors.leftMargin: width
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }

}

