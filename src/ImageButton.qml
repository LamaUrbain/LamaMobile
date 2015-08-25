import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.Marker {
    color: Constants.LAMA_YELLOW
    property alias iconSource: buttonIcon.source

    Image {
        id: buttonIcon
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        anchors.topMargin: parent.height * 0.10
        anchors.bottomMargin: parent.height * 0.10
        anchors.rightMargin: parent.width * 0.10
        anchors.leftMargin: parent.width * 0.10
    }
}
