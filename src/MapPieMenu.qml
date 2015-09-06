import QtQuick 2.0
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

PieMenu {
    id: pieMenu

    style: PieMenuStyle {
        backgroundColor: Constants.LAMA_ORANGE
        selectionColor: Constants.LAMA_YELLOW
        shadowRadius: 0
        title: Text {
            font.pixelSize: Constants.LAMA_POINTSIZE
            color: Constants.LAMA_ORANGE
            text: styleData.text
        }
    }
}
