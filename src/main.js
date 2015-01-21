var lastView = "qrc:/Views/Map.qml"

function navigateTo(name)
{
    lastView = viewLoader.source
    viewLoader.source = name
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
