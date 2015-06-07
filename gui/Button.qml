import QtQuick 2.0
import "qrc:/Components/" as Components

Components.Marker {
    hoverable: true
    signal buttonClicked()
    onClicked: {
        buttonClicked()
    }
}
