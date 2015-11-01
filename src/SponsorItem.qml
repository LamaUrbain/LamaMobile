import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants

RowLayout {
    property var sponsorToDisplay

    signal deleted()

    function raiseDeleted()
    {
        deleted()
    }

    Text
    {
        id: sponsorName
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        color: "white"
        font.pointSize: Constants.LAMA_POINTSIZE
        text: sponsorToDisplay.username
    }
}
