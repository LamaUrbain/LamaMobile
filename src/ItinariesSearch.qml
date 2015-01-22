import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "ViewsLogic.js" as ViewsLogic

Rectangle {
    id: mainContent
    anchors.fill: parent

    Rectangle
    {
        id: viewContent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: commandbar.top
        anchors.rightMargin: parent.width * 0.02
        anchors.leftMargin: anchors.rightMargin
        anchors.topMargin: parent.height * 0.02
        anchors.bottomMargin: anchors.topMargin

        Rectangle
        {
            id: searchInputs
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * (1/4)

            Rectangle
            {
                id: departure
                anchors.left: spliter.left
                anchors.right: spliter.right
                anchors.bottom: spliter.top
                anchors.bottomMargin: Constants.fontSize * 2.2

                Row
                {
                    spacing: Constants.fontSize
                    Text
                    {
                        id: departurePrefix
                        text: "Départ:"
                        font.pixelSize: Constants.fontSize
                        MouseArea
                        {
                            id: departureMA
                            anchors.fill: parent
                            onClicked: { ViewsLogic.displaySuggestionsView(mainContent, departureInput, departureInput.text) }
                            onHoveredChanged:
                            {
                                departurePrefix.color = (departureMA.containsMouse) ? "#555" : "#000"
                            }
                        }
                    }
                    TextInput
                    {
                        id: departureInput
                        text: "Position actuelle"
                        font.pixelSize: Constants.fontSize
                    }
                }
            }

            Rectangle
            {
                id: spliter
                height: 5
                width: parent.width * 0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.15
                color: "#444"
            }

            Rectangle
            {
                id: arrival
                anchors.left: spliter.left
                anchors.right: spliter.right
                anchors.top: spliter.bottom
                anchors.topMargin: Constants.fontSize

                Row
                {
                    spacing: Constants.fontSize
                    Text
                    {
                        id: arrivalPrefix
                        text: "Arrivée:"
                        font.pixelSize: Constants.fontSize
                        MouseArea
                        {
                            id: arrivalMA
                            anchors.fill: parent
                            onClicked: { ViewsLogic.displaySuggestionsView(mainContent, arrivalInput, arrivalInput.text) }
                            onHoveredChanged:
                            {
                                arrivalPrefix.color = (arrivalMA.containsMouse) ? "#555" : "#000"
                            }
                        }
                    }
                    TextInput
                    {
                        id: arrivalInput
                        text: "Recherche"
                        font.pixelSize: Constants.fontSize
                    }
                }
            }

            Controls.SwapButton
            {
                id: swap
                width: Constants.fontSize * 2
                anchors.left: spliter.right
                anchors.leftMargin: width
                anchors.verticalCenter: parent.verticalCenter
                onSwapButtonPressed:
                {
                    var swap = departureInput.text;
                    departureInput.text = arrivalInput.text;
                    arrivalInput.text = swap;
                }
            }
        }

        Rectangle
        {
            id: recentLocations
            anchors.top: searchInputs.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * (1.5/4)

            Rectangle
            {
                id: recentLocationHeader
                anchors.left: parent.left
                anchors.right: parent.right
                height: Constants.fontSize * 1.5
                Text
                {
                    text: "Historique récent"
                    font.pixelSize: Constants.fontSize
                    font.bold: true
                    anchors.left: parent.left;
                }

                Rectangle
                {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * 0.4
                    height: Constants.fontSize

                    TextField
                    {
                        id: recentLocationInput
                        font.pixelSize: Constants.fontSize
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        placeholderText: "Recherche"
                        onEditingFinished:
                        {
                            ViewsLogic.fillRecentLocations(recentLocationModel, recentLocationInput.text)
                        }
                    }
                    Rectangle
                    {
                        color: "#55000000"
                        radius: 5
                        anchors.fill: parent
                    }
                    Image
                    {
                        anchors.right: parent.right
                        height: parent.height
                        width: height
                        source: "qrc:/Assets/Images/loupeIcon.png"
                        opacity: 0.3
                    }
                }
            }

            ScrollView
            {
                anchors.top: recentLocationHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width * 0.1
                anchors.topMargin: parent.height * 0.1
                ListView
                {
                    id: recentLocationList
                    model: ListModel { id: recentLocationModel }
                    delegate:
                    Column
                    {
                        spacing: parent.width * 0.05
                        Text
                        {
                            text: address
                            font.pixelSize: Constants.fontSize
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    recentLocationList.currentIndex = index;
                                    arrivalInput.text = address
                                }
                            }
                        }
                    }
                    highlight: Rectangle { color: "#80CFBF"; radius: 5 }
                }
            }
        }

        Rectangle
        {
            id: favorites
            anchors.top: recentLocations.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * (1.5/4)

            Rectangle
            {
                id: favoritesHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Constants.fontSize * 1.5

                Text
                {
                    text: "Favoris"
                    font.pixelSize: Constants.fontSize
                    font.bold: true
                    anchors.left: parent.left;
                }
            }

            ScrollView
            {
                anchors.top: favoritesHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width * 0.1
                anchors.topMargin: parent.height * 0.1
                ListView
                {
                    id: favoritesList
                    model: ListModel { id: favoritesListModel }
                    Component.onCompleted: { ViewsLogic.fillFavoriteLocations(favoritesListModel) }
                    delegate:
                    Column
                    {
                        spacing: parent.width * 0.05
                        Text
                        {
                            text: address
                            font.pixelSize: Constants.fontSize
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    recentLocationList.currentIndex = index;
                                    arrivalInput.text = address
                                }
                            }
                        }
                    }
                    highlight: Rectangle { color: "#80CFBF"; radius: 5 }
                }
            }
        }
    }

    Components.CommandBar
    {
        id: commandbar

        Controls.MenuButton
        {
            onMenuButtonPressed:
            {
                mainView.navigateToMenu()
            }

            width: parent.width * 0.1
            anchors.leftMargin: width
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        Controls.ReturnButton
        {
            onReturnButtonPressed:
            {
                mainView.navigateBack()
            }

            width: parent.width * 0.1;
            anchors.rightMargin: width;
            anchors.right: validateButton.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        Controls.ValidateButton
        {
            id: validateButton
            onValidateButtonPressed:
            {
                mainView.navigateToMap(departureInput.text, arrivalInput.text)
            }

            width: parent.width * 0.1;
            anchors.rightMargin: width;
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}

