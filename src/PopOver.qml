import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtLocation 5.3
import QtPositioning 5.3
import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

MapQuickItem {
    id: popover
    property alias message: popoverMessage.text
    anchorPoint: Qt.point(popoverItem.width / 2, popoverItem.height)

    sourceItem: Column {
        id: popoverItem

        width: popoverMessage.paintedWidth * 1.4
        height: popoverMessage.paintedHeight * 2

        Components.Marker
        {
            id: rowItem
            color: Constants.LAMA_ORANGE
            radius: 10

            anchors.left: parent.left
            anchors.right: parent.right

            height: popoverMessage.paintedHeight * 1.5

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true

                    Text
                    {
                        id: popoverMessage
                        anchors.centerIn: parent
                        wrapMode: Text.NoWrap
                        color: Constants.LAMA_YELLOW
                        font.pixelSize: Constants.LAMA_POINTSIZE
                        text: "Everything's fine !"
                    }
                }
            }
        }
        Triangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: popoverMessage.paintedHeight * 0.5
            fill: true
            triangleWidth: 10
            lineWidth: 1
            fillStyle: Constants.LAMA_ORANGE
            strokeStyle: Qt.darker(Constants.LAMA_ORANGE, 1.4)
        }
    }
}
