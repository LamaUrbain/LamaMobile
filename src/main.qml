import QtQuick 2.2
import QtQuick.Window 2.1
import "main.js" as JSModule

Window {
    id: mainView
    visible: true
    width: 480
    height: 800

    Loader
    {
        id: viewLoader
        anchors.fill: parent
        source: "qrc:/Views/Map.qml"
    }

    function navigateToSearch()
    {
        JSModule.navigateTo("qrc:/Views/ItinariesSearch.qml")
    }

    function navigateToMenu()
    {
        JSModule.navigateTo("qrc:/Views/Menu.qml")
    }

    function navigateToMap(departure, arrival)
    {
        JSModule.navigateTo("qrc:/Views/Map.qml")
        JSModule.setWaypoints(departure, arrival)
    }

    function navigateBack()
    {
        JSModule.navigateBack()
    }
}
