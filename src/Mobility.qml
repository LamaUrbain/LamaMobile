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

                Grid
                {
                    id: mobilityMeanSelection
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * 0.7
                    columns: 2
                    rows: 3

                    Controls.IconedCheckBox
                    {
                        id: cbpied
                        text: "A pied"
                        Component.onCompleted: setMeanIcon("onfoot")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.ONFOOT, isChecked)
                        }
                    }
                    Controls.IconedCheckBox
                    {
                        id: cbroues
                        text: "Deux roues"
                        Component.onCompleted: setMeanIcon("bike")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.BIKE, isChecked)
                        }
                    }
                    Controls.IconedCheckBox
                    {
                        id: cbVoiture
                        text: "Voiture"
                        Component.onCompleted: setMeanIcon("vehicle")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.VEHICLE, isChecked)
                        }
                    }
                    Controls.IconedCheckBox
                    {
                        id: cbBus
                        text: "Bus"
                        Component.onCompleted: setMeanIcon("bus")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.BUS, isChecked)
                        }
                    }
                    Controls.IconedCheckBox
                    {
                        id: cbTramway
                        text: "Tramway"
                        Component.onCompleted: setMeanIcon("tramway")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.TRAMWAY, isChecked)
                        }
                    }
                    Controls.IconedCheckBox
                    {
                        id: cbTrain
                        text: "Train"
                        Component.onCompleted: setMeanIcon("train")
                        onChecked:
                        {
                            mobilityDiagram.setMeanUsage(MobilityDiagram.TRAIN, isChecked)
                        }
                    }
                }

                Rectangle
                {
                    anchors.right: parent.right
                    anchors.left: mobilityMeanSelection.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Column
                    {
                        spacing: 10
                        anchors.centerIn: parent
                        Button
                        {
                            text: "Ré-initializer"
                            onClicked:
                            {
                                mobilityDiagram.resetDiagram()
                                cbpied.isChecked = true
                                cbroues.isChecked = true
                                cbVoiture.isChecked = true
                                cbBus.isChecked = true
                                cbTramway.isChecked = true
                                cbTrain.isChecked = true
                            }
                        }

                        Button
                        {
                            text: "Ré-équilibrer"
                            onClicked: mobilityDiagram.rearrangeDiagram()
                        }
                    }
                }
            }

            MobilityDiagram
            {
                id: mobilityDiagram
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

