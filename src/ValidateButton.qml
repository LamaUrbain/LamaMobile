import QtQuick 2.0

MouseArea {
    signal validateButtonPressed()
    onClicked : { validateButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/validateIcon.png"
    }
}
