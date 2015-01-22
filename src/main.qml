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

    function navigateFromMenu(name)
    {
        JSModule.navigateTo(name);
    }

    function navigateToProfileSettings()
    {
        JSModule.navigateTo("ProfileSettings");
    }

    function navigateToSearch()
    {
        JSModule.navigateTo("ItinariesSearch");
    }

    function navigateToMenu()
    {
        JSModule.navigateTo("Menu");
    }

    function navigateToMap(departure, arrival)
    {
        JSModule.navigateTo("Map");
        if (departure !== null && arrival !== null)
            JSModule.setWaypoints(departure, arrival);
    }

    function navigateBack()
    {
        JSModule.navigateBack();
    }
}
