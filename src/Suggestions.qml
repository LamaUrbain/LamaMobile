import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/Constants.js" as Constants
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "ViewsLogic.js" as ViewsLogic

Rectangle {
    anchors.fill: parent

    Rectangle
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: suggestionsCommandbar.top

        Rectangle
        {
            id: inputHeader

            height: parent.height * 0.1
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: parent.width * 0.15
            anchors.rightMargin: anchors.leftMargin
            TextField
            {
                id: inputText
                text: ViewsLogic.originTextControl.text
                font.pixelSize: Constants.fontSize
                anchors.fill: parent
                anchors.margins: parent.height * 0.3
                onTextChanged: ViewsLogic.fillSuggestions(suggestionsModel, inputText.text)
            }
        }

        Rectangle
        {
            id: splitter
            height: 3
            width: parent.width * 0.7
            anchors.top: inputHeader.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#D0D0D0"
        }

        ScrollView
        {
            anchors.top: splitter.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.1
            anchors.topMargin: parent.height * 0.1
            ListView
            {
                id: suggestionList
                model: ListModel { id: suggestionsModel }
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
                                suggestionList.currentIndex = index;
                                inputText.text = address
                            }
                        }
                    }
                }
                highlight: Rectangle { color: "#80CFBF"; radius: 5 }
            }
        }
    }

    Components.CommandBar
    {
        id: suggestionsCommandbar

        Controls.ReturnButton
        {
            onReturnButtonPressed:
            {
                ViewsLogic.leaveDisplay(null)
            }

            width: parent.width * 0.1
            anchors.leftMargin: width
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        Controls.ValidateButton
        {
            id: validateButton
            onValidateButtonPressed:
            {
                ViewsLogic.leaveDisplay(inputText.text)
            }

            width: parent.width * 0.1;
            anchors.rightMargin: width;
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}

