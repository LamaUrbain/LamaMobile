import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Button {
    id: deleteButton
    signal deleted()
    Image {
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        anchors.margins: parent.radius * 0.75
        source: Constants.LAMA_CROSS_RESSOURSE
    }
    onClicked: {
        deleted()
    }
}
