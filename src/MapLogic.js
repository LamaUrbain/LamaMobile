function _formatCoords(waypoint)
{
    return (waypoint["latitude"] + ", " + waypoint["longitude"])
}

function getFloatValue(number)
{
    return number.toPrecision(8);
}

function syncItinerary(jsonObj)
{
    if (jsonObj && typeof jsonObj.departure !== "undefined" && typeof jsonObj.destinations !== "undefined")
    {
        rootView.lamaSession.CURRENT_ITINERARY["departure"] =
        {
            address: null,
            latitude: jsonObj.departure.latitude ? getFloatValue(jsonObj.departure.latitude) : null,
            longitude: jsonObj.departure.longitude ? getFloatValue(jsonObj.departure.longitude) : null
        }

        var destinations = jsonObj.destinations;
        rootView.lamaSession.CURRENT_ITINERARY["destinations"] = new Array;

        for (var i = 0; i < destinations.length; ++i)
        {
            var ref = destinations[i];
            var destination =
            {
                address: null,
                latitude: ref.latitude ? getFloatValue(ref.latitude) : null,
                longitude: ref.longitude ? getFloatValue(ref.longitude) : null
            }
            rootView.lamaSession.CURRENT_ITINERARY["destinations"].push(destination);
        }
    }
    else
        console.log("Sync error: " + JSON.stringify(jsonObj));
}

function displayOnUpdateResult(status, jsonStr)
{
    if (status !== 0)
    {
        rootView.modal.title = "Error"
        rootView.modal.message = "We had a hard time updating your itinerary"
        rootView.modal.enableButton = true
        rootView.modal.visible = true
        rootView.modal.setLoadingState(false)
        console.log(status + " --- " + jsonStr);
        return;
    }

    var jsonObj = JSON.parse(jsonStr);
    mapView.mapComponent.displayItinerary(jsonObj["id"]);
    rootView.modal.visible = false;
    syncItinerary(jsonObj);
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
        syncItinerary(jsonObj);
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
            address: null,
            latitude: newCoords.y,
            longitude: newCoords.x
        }
        itineraryServices.editItinerary(itineraryId, "", _formatCoords(rootView.lamaSession.CURRENT_ITINERARY["departure"]), "", function(statusCode, jsonStr)
        {
            rootView.mapView.mapComponent.itineraryChanged();
            if (statusCode == 0)
            {
                var jsonObj = JSON.parse(jsonStr);
                syncItinerary(jsonObj);
            }
        });
    }
    else if (point - 1 < rootView.lamaSession.CURRENT_ITINERARY["destinations"].length)
    {
        rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1] =
        {
            address: null,
            latitude: newCoords.y,
            longitude: newCoords.x
        }
        itineraryServices.editDestination(itineraryId, point - 1, -1, _formatCoords(rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1]), function(statusCode, jsonStr)
        {
            rootView.mapView.mapComponent.itineraryChanged();
            if (statusCode == 0)
            {
                var jsonObj = JSON.parse(jsonStr);
                syncItinerary(jsonObj);
            }
        });
    }
}
