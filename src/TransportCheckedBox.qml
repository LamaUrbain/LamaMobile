import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.Marker {
    property alias iconName: checkedLabel.text
    property alias iconAsset: checkedIcon.source
    checkable: true

    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005
    anchors.bottomMargin: parent.height * 0.005

    Image {
        id: checkedIcon
        width: parent.width * 0.2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        fillMode: Image.PreserveAspectFit
        anchors.margins: parent.radius * 0.25
        anchors.leftMargin: parent.width * 0.10
    }

    Text {
        id: checkedLabel
        font.capitalization: Font.Capitalize
        font.pointSize: Constants.LAMA_POINTSIZE
        renderType: Text.NativeRendering
        color: "white"
        horizontalAlignment: Text.AlignRight
        anchors.centerIn: parent
    }
}
