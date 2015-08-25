import QtQuick 2.0
import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

Rectangle
{
    property alias title: modalTitle.text
    property alias message: modalMessage.text
    property alias buttonText: modalButton.text
    property alias enableButton: buttonZone.visible
    signal modalButtonClicked()
    function setLoadingState(isLoading)
    {
        modalRing.isSpinning(isLoading)
        modalRing.visible = isLoading
        modalMessage.visible = !isLoading
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

    Rectangle
    {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.6
        color: "Transparent"
        Components.Marker
        {
            id: messageZone
            anchors.fill: parent
            anchors.bottomMargin: parent.height * 0.2
            width: parent.width
            height: parent.height * 0.8
            radius: 10
            color: Constants.LAMA_ORANGE

            Text
            {
                id: modalTitle
                height: parent.height * 0.1
                anchors.top: parent.top
                anchors.bottom: modalMessage.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                color: Constants.LAMA_YELLOW
                font.pixelSize: Constants.LAMA_POINTSIZE
                font.weight: Font.Bold
                text: "Information"
            }

            Text
            {
                id: modalMessage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.topMargin: parent.height * 0.1
                wrapMode: Text.WordWrap
                color: Constants.LAMA_YELLOW
                font.pixelSize: Constants.LAMA_POINTSIZE
                text: "Everything's fine !"
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: messageZone.bottom
            anchors.topMargin: messageZone.height * 0.05
            anchors.bottom: parent.bottom
            width: messageZone.width
            radius: 10
            color: Constants.LAMA_YELLOW
            MouseArea
            {
                anchors.fill: parent
                Text
                {
                    id: modalButton
                    anchors.centerIn: parent
                    font.pixelSize: Constants.LAMA_POINTSIZE * 2
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
                    enableButton = true
                }
            }
        }
    }
}

