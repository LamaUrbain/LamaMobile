function _formatCoords(waypoint)
{
    return (waypoint["longitude"] + ", " + waypoint["latitude"])
}

function displayOnUpdateResult(status, json)
{
    if (status !== 0)
    {
        rootView.modal.title = "Error"
        rootView.modal.text = "We had a hard time updating your itinerary"
        rootView.modal.enableButton = true
        rootView.modal.visible = true
        return;
    }

    rootView.mainView.get(0, false).mapComponent.displayItinerary(jsonObj["id"]);
    rootView.modal.visible = false;
}

function updateItinerary(status, json)
{
    if (status !== 0)
    {
        rootView.modal.title = "Error"
        rootView.modal.text = "We had a hard time getting your itinerary"
        rootView.modal.enableButton = true
        rootView.modal.visible = true
        return;
    }

    var currentIt = rootView.lamaSession.CURRENT_ITINERARY;
    var destArray = [];
    for (var idx = 0; idx < currentIt["destinations"].length; ++idx)
        destArray[idx] = _formatCoords(currentIt["destinations"][idx])
    itineraryServices.overwriteItinerary(parseInt(jsonObj["id"]),
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
        rootView.mainView.get(0, false).mapComponent.displayItinerary(parseInt(rootView.lamaSession.CURRENT_ITINERARY['id']));
        rootView.modal.visible = false;
        return;
    }
    rootView.modal.title = "Error"
    rootView.modal.message = "Unfortunatly the llama did not find his way"
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
        mainModal.text = "Sadly, an error occured (MAPVIEW_RESOLV_INVALID_OBJ)"
        mainModal.enableButton = true
        mainModal.visible = true
        return;
    }
    else if (ViewsLogic.isValueAtKeyValid(currentIt, "id") && currentIt['id'] > 0)
        itineraryServices.getItinerary(currentIt['id'], function ()
        {
            return (function(statusCode, jsonStr)
            {
                if (statusCode !== 0)
                {
                    mainModal.title = "Error"
                    mainModal.text = "Sadly, an error occured (MAPVIEW_RESOLV_EXIST_IT_FAIL)"
                    mainModal.enableButton = true
                    mainModal.visible = true
                }
                itineraryServices.getItinerary(currentIt["id"], updateItinerary)
            });
        }());
    else
        createItineraryAndDisplay();
}
