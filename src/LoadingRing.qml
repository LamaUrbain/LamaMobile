import QtQuick 2.5
import QtGraphicalEffects 1.0

Item {
    id: ring
    width: 75
    height: 75

    property alias ringColor: overlay.color

    Image {
        id: spinner
        source: "/Assets/Images/spinnerIcon.png"
        mipmap: true
        anchors.fill: parent

        ColorOverlay {
            id: overlay
            anchors.fill: parent
            source: parent
            color: "white"
        }

        NumberAnimation {
            id: spinRing
            target: spinner
            running: ring.visible
            properties: "rotation"
            from: 0.0
            to: 360.0
            loops: Animation.Infinite
            duration: 1000
       }
    }
}

