import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.Marker {
    color: Constants.LAMA_YELLOW
    property alias iconSource: buttonIcon.source
    property alias text: buttonText.text

    Image {
        id: buttonIcon
        width: parent.width * 0.2

        fillMode: Image.PreserveAspectFit

        anchors.margins: parent.radius * 0.25
        anchors.leftMargin: parent.width * 0.10

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Text {
        id: buttonText

        font.capitalization: Font.Capitalize
        font.pointSize: Constants.LAMA_POINTSIZE
        renderType: Text.NativeRendering

        color: "white"
        horizontalAlignment: Text.AlignRight

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.centerIn: parent
        anchors.right: parent.right
        anchors.left: buttonIcon.rightt
        width: parent.width * 0.8
    }
}
