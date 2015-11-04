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
    return rootView.lamaSession.CURRENT_ITINERARY.owner == ''
            || (rootView.lamaSession.IS_LOGGED
                && rootView.lamaSession.USERNAME
                && rootView.lamaSession.CURRENT_ITINERARY.owner == rootView.lamaSession.USERNAME);
}

function syncItinerary(jsonObj)
{
    if (jsonObj && typeof jsonObj.departure !== "undefined" && typeof jsonObj.destinations !== "undefined")
    {
        rootView.lamaSession.CURRENT_ITINERARY["owner"] = jsonObj.owner ? jsonObj.owner : '';

        rootView.lamaSession.CURRENT_ITINERARY["departure"] =
        {
            address: rootView.lamaSession.CURRENT_ITINERARY["departure"].address,
            latitude: jsonObj.departure.latitude ? getFloatValue(jsonObj.departure.latitude) : null,
            longitude: jsonObj.departure.longitude ? getFloatValue(jsonObj.departure.longitude) : null
        }

        var current_destinations =  rootView.lamaSession.CURRENT_ITINERARY["destinations"]
        var remote_destinations = jsonObj.destinations;
        var new_destinations = new Array;

        for (var i = 0; i < remote_destinations.length; ++i)
        {
            var ref = remote_destinations[i];
            var destination =
            {
                address: ref.address ? ref.address : current_destinations[i].address,
                latitude: ref.latitude ? getFloatValue(ref.latitude) : null,
                longitude: ref.longitude ? getFloatValue(ref.longitude) : null
            }

            if (destination.address || (destination.latitude && destination.longitude))
                new_destinations.push(destination)
        }
        rootView.lamaSession.CURRENT_ITINERARY["destinations"] = new_destinations;
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
    var destAddrArray = [];
    var addr = null;
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
    {
        destArray[idx] = _formatCoords(currentIt["destinations"][idx]);
        destAddrArray[idx] = currentIt["destinations"][idx]["address"];
    }

    if (isItineraryMine())
    {
        itineraryServices.overwriteItinerary(
                    parseInt(currentIt["id"]),
                    currentIt["name"],
                    _formatCoords(currentIt["departure"]),
                    currentIt["departure"]["address"],
                    destArray,
                    destAddrArray,
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
        currentIt['name'] = "Sans nom " + ViewsLogic.getRandomString(8);

    var destArray = [];
    var destAddrArray = [];
    var addr = null;
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
    {
        destArray[idx] = _formatCoords(currentIt["destinations"][idx])
        destAddrArray[idx] = currentIt["destinations"][idx]["address"]
    }

    itineraryServices.createItineraryWith(currentIt["name"],
                                         _formatCoords(currentIt["departure"]),
                                         currentIt["departure"]["address"],
                                         destArray,
                                         destAddrArray,
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
                updateItineraryWith(statusCode, jsonStr);
        });
    else
        createItineraryAndDisplay();
}

function moveItineraryPoint(itineraryId, point, newCoords)
{
    if (point == 0)
    {
        var departure =
        {
            address: null, // Need Cyril geoloc's
            latitude: newCoords.y,
            longitude: newCoords.x
        }

        if (isItineraryMine())
        {
            itineraryServices.editItinerary(itineraryId, "", _formatCoords(departure), departure["address"], "", function(statusCode, jsonStr)
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
        {
            rootView.lamaSession.CURRENT_ITINERARY["departure"] = departure;
            createItineraryAndDisplay();
        }
    }
    else if (point - 1 < rootView.lamaSession.CURRENT_ITINERARY["destinations"].length)
    {
        var waypoint =
        {
            address: null, // Need Cyril geoloc's
            latitude: newCoords.y,
            longitude: newCoords.x
        }

        if (isItineraryMine())
        {
            itineraryServices.editDestination(itineraryId, point - 1, -1, _formatCoords(waypoint), waypoint["address"], function(statusCode, jsonStr)
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
        {
            rootView.lamaSession.CURRENT_ITINERARY["destinations"][point - 1] = waypoint;
            createItineraryAndDisplay();
        }
    }
}

function setDeparture(coord)
{
    if (isItineraryValid())
        moveItineraryPoint(rootView.lamaSession.CURRENT_ITINERARY["id"], 0, coord);
}

function addWaypoint(coord)
{
    if (isItineraryValid())
    {
        var waypoint = {
            address: null, // Need Cyril geoloc's
            latitude: coord.y,
            longitude: coord.x
        }

        if (isItineraryMine())
        {
            itineraryServices.addDestination(
                        rootView.lamaSession.CURRENT_ITINERARY["id"],
                        _formatCoords(waypoint), waypoint["address"],
                        Math.max(0, rootView.lamaSession.CURRENT_ITINERARY["destinations"].length - 1),
                        function(statusCode, jsonStr)
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
        {
            rootView.lamaSession.CURRENT_ITINERARY["destinations"].splice(len - 1, 0, waypoint);
            createItineraryAndDisplay();
        }
    }
}

function setDestination(coord)
{
    if (isItineraryValid())
    {
        moveItineraryPoint(rootView.lamaSession.CURRENT_ITINERARY["id"],
                           rootView.lamaSession.CURRENT_ITINERARY["destinations"].length,
                           coord);
    }
}
