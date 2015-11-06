import QtQuick 2.5
import "qrc:/Components/" as Components

Components.MarkerArea {
    property alias source: buttonIcon.source

    Image {
        id: buttonIcon
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }
}
