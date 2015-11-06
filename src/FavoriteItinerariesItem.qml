import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Constants.js" as Constants

Column {
    id: favoriteItem
    spacing: 8

    property alias name: favoriteText.text
    property int itineraryId: -1
    property bool readOnly: false

    signal displayRequest();
    signal deleteRequest();

    MenuCategory {
        id: favoriteText
        height: 35
        anchors {
            left: parent.left
            right: parent.right
        }
    }

    Row {
        spacing: 8

        Button {
            width: 44
            height: width
            source: Constants.LAMA_SEE_RESSOURCE
            onClicked: displayRequest();
        }

        DeleteButton {
            visible: !readOnly
            width: 44
            height: width
            onDeleted: deleteRequest();
        }

        FacebookButton {
            width: 44
            height: width
            itineraryId: favoriteItem.itineraryId
        }

        TwitterButton {
            width: 44
            height: width
            itineraryId: favoriteItem.itineraryId
        }
    }
}
