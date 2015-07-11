import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/Views/APILogic.js" as APILogic
import "qrc:/UserSession.js" as UserSession

Window {
    id: rootView
    visible: true
    width: 640
    height: 960

    Component.onCompleted: tryLogin()

    signal userSessionChanged()

    StackView {
        id: mainView
        anchors.fill: parent
        initialItem: "qrc:/Views/Map.qml"
    }

    Views.Modal
    {
        id: mainModal
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

    function tryLogin()
    {
        ViewsLogic.checkAndFillFromSavedData() // TODO : UserServices

        if (UserSession.LAMA_USER_USERNAME === null ||
            UserSession.LAMA_USER_PASSWORD === null)
            return;

        var userInfos = ViewsLogic.loginAndCreateToken() // TODO : UserServices
        var userRoutes = ViewsLogic.loadItineraries() // TODO : UserServices
        if (userInfos === null ||
            userRoutes === null)
        {
            mainModal.title = "No internet connexion"
            mainModal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application"
            mainModal.visible = true
        }
        else
        {
            UserSession.LAMA_USER_IS_LOGGED = true
            UserSession.LAMA_USER_TOKEN = userInfos.token
            UserSession.LAMA_USER_EMAIL = userInfos.email
            UserSession.LAMA_USER_AVATAR = userInfos.avatar
            UserSession.LAMA_USER_CURRENT_ITINERARY = {}
            UserSession.LAMA_USER_CURRENT_WAYPOINT_ID = -1
            UserSession.LAMA_USER_CURRENT_WAYPOINT = {}
            UserSession.LAMA_USER_KNOWN_ITINERARIES = userRoutes
        }
    }
}
