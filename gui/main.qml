import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls

Window {
    id: mainView
    visible: true
    width: 640
    height: 960

    property var navigationStack: ["Map"]

    Loader {
        id: mainViewLoader
        anchors.fill: parent
        source: "qrc:/Views/Map.qml"
    }

    function mainViewTo(name, prop) {
        if (name === undefined)
        {
            mainViewTo("Map")
            return
        }

        if (name === "Map") // if we go directly to the map, reset the navstack
        {
            navigationStack = ["Map"]
        }
        else
        {
            navigationStack.push(name)
        }

        if (prop !== undefined)
            mainViewLoader.setSource("qrc:///Views/" + name + ".qml", prop)
        else
            mainViewLoader.setSource("qrc:///Views/" + name + ".qml")
    }
    function mainViewBack() {
        var currentPage = navigationStack.pop();
        mainViewTo(navigationStack.pop())
    }
}

