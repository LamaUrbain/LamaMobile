import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Button {
    id: backToMapButton
    onClicked: {
        if (autoBack)
            rootView.mainViewBack();
    }
    source: Constants.LAMA_BACK_RESSOURSE
    property bool autoBack: true
}
