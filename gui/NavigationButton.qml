import QtQuick 2.0
import "qrc:/Components/" as Components

Button {
    id: navButton
    property string navigationTarget
    onClicked: {
        mainView.mainViewTo(navigationTarget)
    }
}
