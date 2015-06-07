import QtQuick 2.0
import "qrc:/Components/" as Components

Button {
    id: backToMapButton
    iconSource: "qrc:/Assets/Images/returnIcon.png"
    onClicked: {
        mainView.mainViewBack()
    }
}
