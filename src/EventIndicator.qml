import QtQuick 2.5
import "qrc:/Controls" as Controls

Controls.MapItem {
    id: popover
    sourceItem: eventItem

    signal clicked();

    property int eventId: -1

    Image {
        id: eventItem
        width: 36
        height: 54
        source: "qrc:/Images/incident.png"

        MouseArea {
            anchors.fill: parent
            onClicked: popover.clicked();
        }
    }
}
