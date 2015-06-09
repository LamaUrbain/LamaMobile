import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.Marker {
    color: Constants.LAMA_YELLOW
    hoverable: true
    signal buttonClicked()
    onClicked: {
        buttonClicked()
    }
}
