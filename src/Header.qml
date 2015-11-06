import QtQuick 2.5
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Row {
    id: header

    spacing: 15

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    height: backBtn.height

    property bool autoBack: true
    property string title
    property string titleSecondary

    signal backClicked();

    z: 10

    Controls.BackButton {
        id: backBtn
        autoBack: parent.autoBack
        onClicked: backClicked();
    }

    Row {
        id: labelArea
        height: labelTitle.height
        anchors.verticalCenter: parent.verticalCenter

        TextLabel {
            id: labelTitle
            text: header.title
            color: Constants.LAMA_ORANGE
            font.pixelSize: Constants.LAMA_PIXELSIZE + 4
            font.bold: true
        }

        TextLabel {
            text: header.titleSecondary
            color: Constants.LAMA_YELLOW
            font.pixelSize: Constants.LAMA_PIXELSIZE + 4
            font.bold: true
        }
    }
}
