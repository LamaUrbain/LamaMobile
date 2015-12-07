import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "qrc:/Controls/"
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

RowLayout {
    id: waypoint
    height: 50
    spacing: 15
    anchors {
        left: parent.left
        right: parent.right
    }

    property bool isDeparture: false
    property string address: ""
    property alias swapSelected: swapBtn.checked
    property int waypointId: -1

    signal editRequest();
    signal deleteRequest();
    signal swapRequest();

    Components.SwapButton
    {
        id: swapBtn
        Layout.preferredWidth: 50
        Layout.preferredHeight: 50
        onSwapClicked: swapRequest();
    }

    Components.TextField {
        id: waypointText
        text: address
        readOnly: true
        Layout.preferredHeight: 40
        Layout.fillWidth: true
        placeholderText: ""
        font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
        onTextChanged: cursorPosition = 0;

        MouseArea {
            anchors.fill: parent
            onClicked: editRequest();
        }
    }

    DeleteButton {
        id: deleteLabel
        visible: !isDeparture
        Layout.preferredWidth: 50
        Layout.preferredHeight: 50
        onDeleted: deleteRequest();
    }
}
