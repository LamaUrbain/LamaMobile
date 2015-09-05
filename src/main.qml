import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/MapLogic.js" as MapLogic
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Window {
    id: rootView
    visible: true
    width: 640
    height: 960

    Component.onCompleted: UserSession.tryLogin(rootView.lamaSession, false)
    signal userSessionChanged()

    signal triggerLogin(bool clearData)
    onTriggerLogin:
    {
        tryLogin(clearData)
    }

    property var lamaSession: UserSession.LAMA_SESSION
    property alias modal: mainModal
    property alias mainView: mainView
    property QtObject mapView: null

    StackView {
        id: mainView
        anchors.fill: parent
        initialItem: "qrc:/Views/Map.qml"
    }

    Views.Modal
    {
        id: mainModal
        Component.onCompleted: rootView.lamaSession.mainModal = mainModal
    }

    function mainViewTo(name, prop)
    {
        if (name === undefined || name === "Map")
        {
            // Pops all but the first item (i.e. the map)
            mainView.pop(null);
        }
        else
        {
            mainView.push("qrc:/Views/" + name + ".qml", {properties: prop})
        }
    }

    function mainViewBack()
    {
        if (mainView.currentItem != mapView)
            mainView.pop()
    }

    function raiseUserSessionChanged()
    {
        userSessionChanged()
    }

    function resolveCurrentItinerary()
    {
        MapLogic.resolveCurrentItinerary()
    }

    function tryLogin(clear)
    {
        UserSession.tryLogin(clear)
    }
}
