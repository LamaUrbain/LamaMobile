import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/Constants.js" as Constants

Rectangle
{
    property alias errorMessage: errorTxt
    anchors.fill: parent
    visible: false
    color: "#000"
    opacity: 0.8

    Rectangle
    {
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.4
        Text
        {
            id: errorTxt
            anchors.centerIn: parent
            anchors.margins: parent.width * 0.01
            font.pixelSize: Constants.fontSize
            color: "#000"
        }
        Button
        {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Constants.fontSize * 2
            text: "Ok"

            onClicked:
            {
                parent.parent.visible = false
            }
        }
    }
}
