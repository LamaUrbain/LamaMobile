import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/Constants.js" as Constants

Rectangle {
    property alias text: checkBox.text
    property alias isChecked: checkBox.checked
    signal checked

    function setMeanIcon(iconName)
    {
        icon.source = "qrc:/Assets/Images/" + iconName + "Mean.png"
    }

    height: parent.height * 0.4
    width: parent.width * 0.5

    Image
    {
        id: icon
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: Constants.fontSize * 2
        height: width
    }

    CheckBox
    {
        id: checkBox
        anchors.left: icon.right
        anchors.leftMargin: icon.width * 0.5
        anchors.verticalCenter: parent.verticalCenter

        checked: true
        onCheckedChanged: parent.checked()
    }
}

