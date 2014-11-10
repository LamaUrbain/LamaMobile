import QtQuick 2.2
import QtQuick.Window 2.1
import MobilityDiagramTest 1.0

Window {
    visible: true
    width: 360
    height: 360

    MobilityDiagram {
        anchors.fill: parent
        Component.onCompleted: console.log(MobilityDiagram.ONFOOT)
    }
}
