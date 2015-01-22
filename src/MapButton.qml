import QtQuick 2.0

MouseArea {
    signal mapButtonPressed()
    onClicked : { mapButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/mapIcon.png"
    }
}

