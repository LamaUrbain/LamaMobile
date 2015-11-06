import QtQuick 2.5

Item {
    signal cancelRequest();

    MouseArea {
        anchors.fill: parent
        onClicked: parent.cancelRequest();
    }
}
