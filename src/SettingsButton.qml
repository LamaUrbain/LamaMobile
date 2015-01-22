import QtQuick 2.0

MouseArea {
    signal settingsButtonPressed()
    onClicked : { settingsButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/settingsIcon.png"
    }
}
