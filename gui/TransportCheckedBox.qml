import QtQuick 2.0
import "qrc:/Components/" as Components

Components.Marker {
    property string iconName
    checkable: true

    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005
    anchors.bottomMargin: parent.height * 0.005

    onIconNameChanged: {
        checkedIcon.source = "qrc:/Assets/Images/" + iconName + "Mean.png"
        checkedLabel.text = iconName + " Selection"
    }

    Image {
        id: checkedIcon
        width: parent.width * 0.2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        fillMode: Image.PreserveAspectFit
        anchors.leftMargin: parent.height * 0.1
    }

    Text {
        id: checkedLabel
        font.capitalization: Font.Capitalize
        anchors.centerIn: parent
        font.pixelSize: 12
        renderType: Text.NativeRendering
        color: "white"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: checkedIcon.right
        anchors.right: parent.right
    }
}
