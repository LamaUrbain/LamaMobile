import QtQuick 2.0
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Constants.js" as Constants

IconButton
{
    id: shareButton
    text: "Share"
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    height: parent.height
    iconSource: Constants.LAMA_SHARE_RESSOURCE
    onClicked: {
        ViewsLogic.spawnModal("Share", "...")
    }
}
