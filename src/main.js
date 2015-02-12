var lastView = "Map"
var currentView = "Map"

function navigateTo(name)
{
    lastView = currentView
    currentView = name
    if (name === "Map")
        viewLoader.source = ""
    else
        viewLoader.source = "qrc:/Views/" + name + ".qml"
    return (viewLoader.sourceComponent)
}

function navigateBack()
{
    if (lastView != viewLoader.source)
        JSModule.navigateTo(lastView)
}

function setWaypoints(mapView, departure, arrival)
{
    // Treat data to nodes
    // Call louis code with nodes
}
