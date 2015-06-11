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
    console.log("CreateItinerary Response : " + statusCode + '(' + (statusCode == 0) + ')');
    if (statusCode == 0)
    {
        var jsonObj = JSON.parse(jsonStr)
        console.log("CreateItinerary Response Id : " + jsonObj["id"]);
        mapView.mapComponent.displayItinerary(jsonObj["id"]);
    }
    else
        onIniteraryRequestFailure(statusCode, "Malheureusement le llama n'a pas trouvé de chemain")
}

function setWaypoints(mapView, departure, arrival, waypoints)
{
    //var points = new Array;
    //
    //var dep = new Object;
    //dep["type"] = "coord";
    //dep["content"] = new Object;
    //dep["content"]["latitude"] =  departure.split(", ")[0];//49.8964;
    //dep["content"]["longitude"] = departure.split(", ")[1];//2.2957;
    //points.push(dep);
    //
    //var arr = new Object;
    //arr["type"] = "coord";
    //arr["content"] = new Object;
    //arr["content"]["latitude"] =  arrival.split(", ")[0];//49.4337;
    //arr["content"]["longitude"] = arrival.split(", ")[1];//2.0888;
    //points.push(arr);

    //points.push(departure)
    //if (points && points.constructor === Array)
        //for (var id = 0; index < points.length; ++id)
            //points.push(waypoints[i])
    //points.push(arrival)

    departure = departure.split(new RegExp("[,;] *"));
    departure = departure[0] + ',' + departure[1];
    if (arrival)
    {
        arrival = arrival.split(new RegExp("[,;] *"));
        arrival = arrival[0] + ',' + arrival[1];
    }
    var name = "tempItinerary" + (Date.now());

    //itineraryServices.abortPendingRequests()
    itineraryServices.createItinerary(name, departure, arrival, false, onItineraryCreateResponse)
}
