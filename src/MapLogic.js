function _formatCoords(waypoint)
{
    return (waypoint["latitude"] + ", " + waypoint["longitude"])
}

function getFloatValue(number)
{
    return number.toPrecision(8);
}

function isItineraryValid()
{
    return rootView.lamaSession.CURRENT_ITINERARY != undefined
            && rootView.lamaSession.CURRENT_ITINERARY.departure != undefined;
}

function isItineraryMine()
{
    return !rootView.lamaSession.CURRENT_ITINERARY.owner
            || (rootView.lamaSession.IS_LOGGED
                && rootView.lamaSession.USERNAME
                && rootView.lamaSession.CURRENT_ITINERARY.owner == rootView.lamaSession.USERNAME);
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

            if (destination.address || (destination.latitude && destination.longitude))
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

function updateItinerary()
{
    var currentIt = rootView.lamaSession.CURRENT_ITINERARY;
    var destArray = [];
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
        destArray[idx] = _formatCoords(currentIt["destinations"][idx])

    if (isItineraryMine())
    {
        itineraryServices.overwriteItinerary(
                    parseInt(currentIt["id"]),
                    currentIt["name"],
                    _formatCoords(currentIt["departure"]),
                    destArray,
                    currentIt["favorite"] === true ? "true" : "false", displayOnUpdateResult);
    }
    else
        createItineraryAndDisplay();
}

function updateItineraryWith(status, jsonObj)
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

    updateItinerary();
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
                itineraryServices.getItinerary(currentIt["id"], updateItineraryWith)
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

        if (isItineraryMine())
        {
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
        else
            createItineraryAndDisplay();
    }
    else if (point - 1 < rootView.lamaSession.CURRENT_ITINERARY["destinations"].length)
    {
        rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1] =
        {
            address: null,
            latitude: newCoords.y,
            longitude: newCoords.x
        }

        if (isItineraryMine())
        {
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
        else
            createItineraryAndDisplay();
    }
}

function addDeparture(coord)
{
    if (isItineraryValid())
    {
        if (rootView.lamaSession.CURRENT_ITINERARY["destinations"] !== undefined)
        {
            var departure = {
                address: rootView.lamaSession.CURRENT_ITINERARY["departure"].address,
                latitude: rootView.lamaSession.CURRENT_ITINERARY["departure"].latitude,
                longitude: rootView.lamaSession.CURRENT_ITINERARY["departure"].longitude
            }

            rootView.lamaSession.CURRENT_ITINERARY["destinations"].unshift(departure);
        }

        rootView.lamaSession.CURRENT_ITINERARY["departure"] =
        {
            address: null,
            latitude: coord.y,
            longitude: coord.x
        }

        if (isItineraryMine())
            updateItinerary();
        else
            createItineraryAndDisplay();
    }
}

function addWaypoint(coord)
{
    if (isItineraryValid())
    {
        if (rootView.lamaSession.CURRENT_ITINERARY["destinations"] !== undefined)
        {
            var len = rootView.lamaSession.CURRENT_ITINERARY["destinations"].length;

            if (len == 0)
            {
                addDestination(coord);
                return;
            }

            var waypoint = {
                address: null,
                latitude: coord.y,
                longitude: coord.x
            }

            rootView.lamaSession.CURRENT_ITINERARY["destinations"].splice(len - 1, 0, waypoint);
        }

        if (isItineraryMine())
            updateItinerary();
        else
            createItineraryAndDisplay();
    }
}

function addDestination(coord)
{
    if (isItineraryValid())
    {
        var waypoint = {
            address: null,
            latitude: coord.y,
            longitude: coord.x
        }

        rootView.lamaSession.CURRENT_ITINERARY["destinations"].push(waypoint);

        if (isItineraryMine())
        {
            itineraryServices.addDestination(rootView.lamaSession.CURRENT_ITINERARY["id"], _formatCoords(waypoint), -1, function(statusCode, jsonStr)
            {
                rootView.mapView.mapComponent.itineraryChanged();
                if (statusCode == 0)
                {
                    var jsonObj = JSON.parse(jsonStr);
                    syncItinerary(jsonObj);
                }
            });
        }
        else
            createItineraryAndDisplay();
    }
}
