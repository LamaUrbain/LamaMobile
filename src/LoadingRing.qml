import QtQuick 2.5

Item {
    id: ring
    width: 75
    height: 75

    Image {
        id: spinner
        source: "/Assets/Images/spinnerIcon.png"
        mipmap: true
        anchors.fill: parent

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

