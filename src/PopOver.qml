import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtLocation 5.3
import QtPositioning 5.3
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/Constants.js" as Constants

MapQuickItem {
    id: popover
    property alias message: popoverMessage.text
    property Address address

    anchorPoint: Qt.point(popoverItem.width / 2, popoverItem.height)

    property string popOverType: "waypoint"

    function setAddress(addr)
    {
        address = addr;
        popoverMessage.text = "%1, %2".arg(addr.street).arg(addr.district)
    }

    sourceItem: Column {
        id: popoverItem

        width: popoverMessage.paintedWidth + 75
        height: (popoverMessage.paintedHeight + popoverImage.paintedHeight) *  1.2

        Components.Marker
        {
            id: rowItem
            color: Constants.LAMA_YELLOW
            radius: 10

            anchors.left: parent.left
            anchors.right: parent.right

            height: popoverMessage.paintedHeight * 1.5

            RowLayout {
                anchors.fill: parent

                Text
                {
                    Layout.fillWidth: true
                    id: popoverMessage

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    anchors.topMargin: popoverMessage.paintedHeight * 0.25
                    anchors.bottomMargin: popoverMessage.paintedHeight * 0.25

                    wrapMode: Text.NoWrap
                    color: Constants.LAMA_ORANGE
                    font.pixelSize: Constants.LAMA_POINTSIZE
                }

                Controls.DeleteButton {
                    color: Constants.LAMA_ORANGE

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Layout.preferredWidth: 35

                    onDeleted: {
                        popover.destroy()
                    }
                }
            }
        }
        Image {
            id: popoverImage
            fillMode: Image.Pad
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            source: {
                switch (popOverType)
                {
                default:
                case "waypoint":
                    Constants.LAMA_INDICATOR_RESSOURCE;
                    break;
                case "departure":
                    Constants.LAMA_DEPARTURE_RESSOURCE;
                    break;
                case "arrival":
                    Constants.LAMA_ARRIVAL_RESSOURCE;
                    break;
                }
            }
        }
    }
}
