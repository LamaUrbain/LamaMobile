import QtQuick 2.0

MouseArea {
    signal swapButtonPressed()
    onClicked : { swapButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/swapIcon.png"
    }
}
