import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Button {
    id: backToMapButton
    Image {
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        smooth: true
        source: Constants.LAMA_BACK_RESSOURSE
        anchors.margins: parent.radius * 0.25
    }
    onClicked: {
        rootView.mainViewBack()
    }
}
