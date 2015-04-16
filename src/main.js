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
        itineraryServices.displayItinerary(jsonObj["id"])
    }
    else
        onIniteraryRequestFailure(statusCode, "Malheureusement le llama n'a pas trouvé de chemain")
}

function setWaypoints(mapView, departure, arrival)
{
    var points = new Array
    points.push(departure)
    points.push(arrival)
    itineraryServices.abortPendingRequests()
    itineraryServices.createItinerary(points, onItineraryCreateResponse)
}
