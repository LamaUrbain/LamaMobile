import QtQuick 2.5
import "qrc:/Components/" as Components

Components.MarkerInput {
    id: menuButton
    height: 50

    property string icon: ""
    property string text: ""

    Components.TextLabel {
        text: parent.text
        color: "#FFF"
        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }
    }

    Image {
        width: 28
        height: 28
        mipmap: true
        source: menuButton.icon
        fillMode: Image.PreserveAspectFit
        anchors {
            right: parent.right
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }
    }
}
