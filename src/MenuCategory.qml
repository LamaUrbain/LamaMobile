import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.MarkerInput {
    id: menuButton
    height: 30
    hoverable: false
    color1: Constants.LAMA_ORANGE
    borderColor1: Constants.LAMA_BORDER_COLOR2

    property string text: ""
    property alias textArea: textArea

    Components.TextLabel {
        id: textArea
        text: parent.text
        font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
        color: "#FFF"
        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }
    }
}
