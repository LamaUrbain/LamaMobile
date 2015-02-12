import QtQuick 2.2
import QtQuick.Window 2.1
import "main.js" as JSModule
import "qrc:/Views" as Views

Window {
    id: mainView
    visible: true
    width: 480
    height: 800

    Views.Map
    {
        id: mapView
    }

    Loader
    {
        id: viewLoader
        anchors.fill: parent
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
            JSModule.setWaypoints(mapView, departure, arrival);
    }

    function navigateBack()
    {
        JSModule.navigateBack();
    }
}
