import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/APILogic.js" as APILogic
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Window {
    id: rootView
    visible: true
    width: 640
    height: 960

    Component.onCompleted: UserSession.tryLogin(rootView.lamaSession, false)
    signal userSessionChanged()

    property var lamaSession: UserSession.LAMA_SESSION
    property alias modal: mainModal

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

    function mainViewTo(name, prop) {
        if (name === undefined)
        {
            mainViewTo("Map")
            return
        }

        if (name === "Map") // if we go directly to the map, reset the navstack
        {
            mainView.clear()
            mainView.push("qrc:/Views/Map.qml")
        }
        else
        {
            mainView.push("qrc:/Views/" + name + ".qml", {properties: prop})
        }
    }

    function mainViewBack() {
        mainView.pop()
    }

    function raiseUserSessionChanged()
    {
        userSessionChanged()
    }

    function resolveCurrentItinerary()
    {
        mainView.get(0, false).resolveCurrentItinerary()
    }
}
