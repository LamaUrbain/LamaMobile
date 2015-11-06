import QtQuick 2.5
import QtGraphicalEffects 1.0
import "qrc:/Constants.js" as Constants

MouseArea {
    id: menuButton
    width: 70
    height: 70
    opacity: menuButton.pressed ? 0.9 : 1
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        radius: 8
        samples: 8
        color: menuButton.pressed ? "#88000000" : "#000"
    }

    Image {
        id: menuImg
        mipmap: true
        source: Constants.LAMA_ITINERARY_RESSOURCE
        anchors.centerIn: parent
        fillMode: Image.Stretch
        width: 43
        height: 51
    }
}
