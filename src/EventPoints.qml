import QtQuick 2.0
import "qrc:/Controls" as Controls
import "qrc:/Constants.js" as Constants

Controls.MapItem {
    id: mapEventPoint
    sourceItem: mapEventItem

    Image {
        id: mapEventItem
        source: Constants.LAMA_INDICATOR_RESSOURCE
    }
}
