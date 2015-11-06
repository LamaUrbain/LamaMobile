import QtQuick 2.5
import "qrc:/Components/" as Components

Components.MarkerInput {
    width: 55
    height: 55
    radius: 10

    property alias image: imageArea
    property string source: ""
    signal buttonClicked()

    onClicked: {
        buttonClicked();
    }

    Image {
        id: imageArea
        source: parent.source
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        width: Math.floor(Math.min(parent.width, parent.height) / 2)
        height: width
        mipmap: true
    }
}
