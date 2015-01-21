import QtQuick 2.0

MouseArea {
    signal returnButtonPressed()
    onClicked : { returnButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/returnIcon.png"
    }
}
