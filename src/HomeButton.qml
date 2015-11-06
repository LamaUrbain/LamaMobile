import QtQuick 2.5
import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

Components.MarkerArea {
    width: buttonImg.width
    height: buttonImg.height
    opacity: pressed ? 0.8 : 1

    Image {
        id: buttonImg
        source: Constants.LAMA_HOME
    }
}

