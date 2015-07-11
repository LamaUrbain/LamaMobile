import QtQuick 2.0
import QtGraphicalEffects 1.0
import "qrc:/Constants.js" as Constants

Rectangle {

    property alias ringColor: overlay.color

    function isSpinning(enableSpin)
    {
        if (enableSpin)
        {
            spinRing.start()
        }
        else
        {
            spinRing.stop()
            spinner.rotation = 0
        }
    }

    width: parent.width / 4
    height: width
    color: "Transparent"

    Image {
        id: spinner
        source: "/Assets/Images/spinnerIcon.png"
        anchors.fill: parent

        ColorOverlay
        {
            id: overlay
            anchors.fill: parent
            source: parent
            color: "white"
        }
        NumberAnimation
        {
            id: spinRing
            target: spinner
            properties: "rotation"
            from: 0.0
            to: 360.0
            loops: Animation.Infinite
            duration: 1000
       }
    }
}

