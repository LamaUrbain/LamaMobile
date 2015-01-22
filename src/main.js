var lastView = "Map"
var currentView = "Map"

function navigateTo(name)
{
    lastView = currentView
    currentView = name
    viewLoader.source = "qrc:/Views/" + name + ".qml"
    return (viewLoader.sourceComponent)
}

function navigateBack()
{
    if (lastView != viewLoader.source)
        JSModule.navigateTo(lastView)
}

function setWaypoints(departure, arrival)
{
    // Treat data to nodes
    // Call louis code with nodes
}
