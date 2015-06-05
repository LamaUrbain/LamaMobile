import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components

Window {
    id: mainView
    visible: true
    width: 640
    height: 960

    Loader {
        id: mainViewLoader
        anchors.fill: parent
        source: "qrc:/Views/FavoriteItineraries.qml"
    }

    function changeViewTo(name) {
        mainViewLoader.source = "qrc:/Views/" + name + ".qml"
    }
}

