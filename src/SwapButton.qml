import QtQuick 2.5
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Controls.Button {
    id: swapButton
    source: Constants.LAMA_CURVEDARROW_RESSOURCE
    signal swapClicked();
    onClicked: swapClicked();
    checkable: true;
}
