import QtQuick 2.0

MouseArea {
    signal menuButtonPressed()
    onClicked : { menuButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/menuIcon.png"
    }
}

