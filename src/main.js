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
    var points = new Array;

    var dep = new Object;
    dep["type"] = "coord";
    dep["content"] = new Object;
    dep["content"]["latitude"] = 49.8964;
    dep["content"]["longitude"] = 2.2957;
    points.push(dep);

    var arr = new Object;
    dep["type"] = "coord";
    dep["content"] = new Object;
    dep["content"]["latitude"] = 49.4337;
    dep["content"]["longitude"] = 2.0888;
    points.push(arr);

    //points.push(departure)
    //if (points && points.constructor === Array)
        //for (var id = 0; index < points.length; ++id)
            //points.push(waypoints[i])
    //points.push(arrival)

    itineraryServices.abortPendingRequests()
    itineraryServices.createItinerary(points, onItineraryCreateResponse)
}
