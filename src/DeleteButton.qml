import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Button {
    id: deleteButton
    source: Constants.LAMA_CROSS_RESSOURSE
    signal deleted();
    onClicked: deleted();
}
