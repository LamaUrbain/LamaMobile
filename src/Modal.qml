import QtQuick 2.0
import QtQuick.Layouts 1.2
import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

Rectangle
{
    property alias title: modalTitle.text
    property alias buttonText: modalButton.text
    property alias enableButton: buttonZone.visible
    property alias message: modalContentLoader.message
    property alias modalSourceComponent: modalContentLoader.sourceComponent

    signal modalButtonClicked()

    function setLoadingState(isLoading)
    {
        modalRing.isSpinning(isLoading)
        modalRing.visible = isLoading
        modalContentLoader.visible = !isLoading
    }

    id: modal
    anchors.fill: parent
    color: "#AA000000"
    visible: false

    MouseArea
    {
        anchors.fill:parent
        propagateComposedEvents: false
        preventStealing: true
    }

    Column
    {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.6
        spacing: height * 0.025

        Components.Marker
        {
            id: messageZone
            anchors.left: parent.left
            anchors.right: parent.right
            color: Constants.LAMA_ORANGE
            height: parent.height * 0.8
            radius: 10

            Text
            {
                id: modalTitle
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.05
                anchors.left: parent.left
                anchors.right: parent.right

                color: Constants.LAMA_YELLOW
                Layout.minimumHeight: parent.height * 0.1
                Layout.preferredHeight: parent.height * 0.1

                font.pixelSize: Constants.LAMA_POINTSIZE
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "Information"
                wrapMode: Text.WordWrap
            }

            Loader
            {
                id: modalContentLoader
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.fillHeight: true

                property string message: "Everything's fine !"

                sourceComponent: modalMessageItem

                Component {
                    id: modalMessageItem

                    Text
                    {
                        id: modalMessage
                        anchors.fill: parent

                        color: Constants.LAMA_YELLOW
                        font.pixelSize: Constants.LAMA_POINTSIZE
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: message
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Components.LoadingRing
            {
                id: modalRing
                anchors.centerIn: parent
                ringColor: Constants.LAMA_YELLOW
                visible: false
            }
        }

        Components.Marker
        {
            id: buttonZone
            anchors.left: parent.left
            anchors.right: parent.right
            color: Constants.LAMA_YELLOW
            height: parent.height * 0.2
            radius: 10

            MouseArea
            {
                anchors.fill: parent
                Text
                {
                    id: modalButton
                    anchors.centerIn: parent
                    font.pixelSize: Constants.LAMA_POINTSIZE * 2
                    color: "white"
                    text: "Ok"
                    font.weight: Font.Bold
                }
                onClicked:
                {
                    modalButtonClicked()
                    modal.visible = false
                    title = "Information"
                    message = "Everything's fine !"
                    buttonText = "Ok"
                    setLoadingState(false)
                    modalContentLoader.sourceComponent = modalMessageItem
                    enableButton = true
                }
            }
        }
    }
}

