function _formatCoords(waypoint)
{
    return (waypoint["longitude"] + ", " + waypoint["latitude"])
}

function displayOnUpdateResult(status, jsonObj)
{
    if (status !== 0)
    {
        rootView.modal.title = "Error"
        rootView.modal.message = "We had a hard time updating your itinerary"
        rootView.modal.enableButton = true
        rootView.modal.visible = true
        rootView.modal.setLoadingState(false)
        return;
    }

    mapView.mapComponent.displayItinerary(jsonObj["id"]);
    rootView.modal.visible = false;
}

function updateItinerary(status, jsonObj)
{
    if (status !== 0)
    {
        rootView.modal.title = "Error"
        rootView.modal.message = "We had a hard time getting your itinerary"
        rootView.modal.enableButton = true
        rootView.modal.visible = true
        rootView.modal.setLoadingState(false)
        return;
    }

    var currentIt = rootView.lamaSession.CURRENT_ITINERARY;
    var destArray = [];
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
        destArray[idx] = _formatCoords(currentIt["destinations"][idx])
    itineraryServices.overwriteItinerary(parseInt(currentIt["id"]),
                                         currentIt["name"],
                                         _formatCoords(currentIt["departure"]),
                                         destArray,
                                         currentIt["favorite"] === true ? "true" : "false",
                                         displayOnUpdateResult);
}

function onCreateItineraryWith(statusCode, jsonStr)
{
    console.log("CreateItinerary Response Status : " + statusCode);
    if (statusCode === 0)
    {
        var jsonObj = JSON.parse(jsonStr)
        var ItId = jsonObj["id"]
        console.log("CreateItinerary Response Id : " + ItId);
        rootView.lamaSession.CURRENT_ITINERARY['id'] = ItId;
        mapView.mapComponent.displayItinerary(parseInt(rootView.lamaSession.CURRENT_ITINERARY['id']));
        rootView.modal.visible = false;
        return;
    }
    rootView.modal.title = "Error"
    rootView.modal.message = "Unfortunatly the lama did not find his way"
    rootView.modal.enableButton = true
    rootView.modal.setLoadingState(false)
}

function createItineraryAndDisplay()
{
    var currentIt = rootView.lamaSession.CURRENT_ITINERARY

    if (currentIt['name'] === null || currentIt['name'] === '')
        currentIt['name'] = "tmp_itinerary_" + ViewsLogic.getRandomString(8);

    //itineraryServices.abortPendingRequests()

    var destArray = [];
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
        destArray[idx] = _formatCoords(currentIt["destinations"][idx])
    itineraryServices.createItineraryWith(currentIt["name"],
                                         _formatCoords(currentIt["departure"]),
                                         destArray,
                                         currentIt["favorite"] === true ? "true" : "false",
                                         onCreateItineraryWith);
}

function resolveCurrentItinerary()
{
    mainModal.title = "Resolving itinierary"
    mainModal.setLoadingState(true)
    mainModal.enableButton = false
    mainModal.visible = true

    var currentIt = rootView.lamaSession.CURRENT_ITINERARY;

    if (!ViewsLogic.isValueAtKeyValid(currentIt, "departure")
            || !ViewsLogic.isValueAtKeyValid(currentIt, "destinations"))
    {
        mainModal.title = "Error"
        mainModal.message = "Sadly, an error occured (MAPVIEW_RESOLV_INVALID_OBJ)"
        mainModal.enableButton = true
        mainModal.visible = true
        rootView.modal.setLoadingState(false)
        return;
    }
    else if (ViewsLogic.isValueAtKeyValid(currentIt, "id") && currentIt['id'] > 0)
        itineraryServices.getItinerary(currentIt['id'], function(statusCode, jsonStr)
        {
            if (statusCode !== 0)
            {
                mainModal.title = "Error"
                mainModal.message = "Sadly, an error occured (MAPVIEW_RESOLV_EXIST_IT_FAIL)"
                mainModal.enableButton = true
                mainModal.visible = true
                rootView.modal.setLoadingState(false)
            }
            else
            {
                var currentIt = rootView.lamaSession.CURRENT_ITINERARY;
                itineraryServices.getItinerary(currentIt["id"], updateItinerary)
            }
        });
    else
        createItineraryAndDisplay();
}

function moveItineraryPoint(itineraryId, point, newCoords)
{
    if (point == 0)
    {
        rootView.lamaSession.CURRENT_ITINERARY["departure"] =
        {
            address: "You moved it",
            latitude: newCoords.x,
            longitude: newCoords.y
        }
        itineraryServices.editItinerary(itineraryId, "", _formatCoords(rootView.lamaSession.CURRENT_ITINERARY["departure"]), "", function(statusCode, jsonStr)
        {
            rootView.mapView.mapComponent.itineraryChanged();
        });
    }
    else if (point - 1 < rootView.lamaSession.CURRENT_ITINERARY["destinations"].length)
    {
        rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1] =
        {
            address: "You moved it",
            latitude: newCoords.x,
            longitude: newCoords.y
        }
        itineraryServices.editDestination(itineraryId, point - 1, -1, _formatCoords(rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1]), function(statusCode, jsonStr)
        {
            rootView.mapView.mapComponent.itineraryChanged();
        });
    }
}
