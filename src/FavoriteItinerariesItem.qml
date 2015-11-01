import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants

RowLayout {
    property alias favoriteDescription: favoriteText.centerText
    property var linkedItinerary: Constants.LAMA_BASE_ITINERARY_OBJ
    property bool readOnly: false

    signal deleted()

    function raiseDeleted()
    {
        deleted()
    }

    NavigationButton {
        id: favoriteText
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.fillWidth: true
        navigationTarget: "MainSearch"
        onNavButtonPressed:
        {
            rootView.lamaSession.CURRENT_ITINERARY = linkedItinerary
            //rootView.raiseUserSessionChanged()
        }
    }

    DeleteButton {
        id: deleteLabel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.minimumWidth: parent.width * 0.1
        Layout.maximumWidth: parent.width * 0.15
        Layout.preferredWidth: parent.width * 0.12
        visible: readOnly == false
        onDeleted: {
            raiseDeleted()
        }
    }
}
