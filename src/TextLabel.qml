import QtQuick 2.5
import QtQuick.Controls 1.3
import App 1.0
import "qrc:/Constants.js" as Constants

Text {
    color: Constants.LAMA_FONTCOLOR
    font.pixelSize: Constants.LAMA_PIXELSIZE
    font.family: ApplicationFont.name
    renderType: Text.QtRendering
}
