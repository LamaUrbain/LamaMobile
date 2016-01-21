import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.MarkerInput {
    height: 40
    implicitHeight: 40
    checkable: true

    property string source: ""
    property string text: ""

    Components.TextLabel {
        text: parent.text
        color: "#FFF"
        font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 10
    }

    Image {
        width: 25
        height: 25
        mipmap: true
        source: parent.source
        fillMode: Image.PreserveAspectFit
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 15
        }
    }
}
