import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession

RowLayout {
    property alias sponsorDescription: favoriteText.centerText

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
            rootView.raiseUserSessionChanged()
        }
    }
}
