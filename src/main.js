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

function onIniteraryRequestFailure(code, details)
{
    errorPopup.errorMessage = details
    errorPopup.visible = true
}

function onItineraryCreateResponse(statusCode, jsonStr)
{
    if (statusCode === 0)
    {
        var jsonObj = JSON.parse(jsonStr)
        mapView.mapComponent.displayItinerary(jsonObj["id"])
    }
    else
        onIniteraryRequestFailure(statusCode, "Malheureusement le llama n'a pas trouvé de chemain")
}

function setWaypoints(mapView, departure, arrival, waypoints)
{
    var points = new Array

    //points.push(departure)
    points.push("{ type: \”coor​d\”, content: {\"latitude\": 48.815756, \"longitude\": 2.362841} }")
    //points.push("{ type: \”coor​d\”, content: {\"latitude\": 48.814775, \"longitude\": 2.362305} }")
    if (points && points.constructor === Array)
        for (var id = 0; index < points.length; ++id)
            points.push(waypoints[i])
    //points.push(arrival)
    points.push("{ type: \”coor​d\”, content: {\"latitude\": 48.812018, \"longitude\": 2.361859} }")

    itineraryServices.abortPendingRequests()
    itineraryServices.createItinerary(points, onItineraryCreateResponse)
}
