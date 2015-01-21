import QtQuick 2.0

MouseArea {
    signal searchButtonPressed()
    onClicked : { searchButtonPressed() }
    height: width

    Image
    {
        anchors.fill: parent
        source: "qrc:/Assets/Images/searchIcon.png"
    }
}

