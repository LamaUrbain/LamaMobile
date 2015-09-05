
function proceedToAddWayPoints(wayPointsArray)
{
    var wayPointCount = wayPointsArray.length; // Fucking flies because of dereferencement

    if (wayPointCount === 0)
    {
        rootView.mainView.get(0, false).mapComponent.displayItinerary(parseInt(rootView.lamaSession.CURRENT_ITINERARY['id']));
        rootView.modal.visible = false;
    }
    else
    {
        for (var idx = 0; idx < wayPointCount; ++idx)
        {
            itineraryServices.addDestination(itineraryId, wayPointsArray[idx], idx,
                                             function (idx)
            {
                return (function(statusCode, jsonStr)
                {
                    if (statusCode !== 0)
                    {
                        rootView.modal.title = "Error"
                        rootView.modal.text = "Sadly, an error occured (MAPVIEW_RESOLV_DEST_ADD_FAIL)"
                        rootView.modal.enableButton = true
                        rootView.modal.visible = true
                    }

                    if (idx + 1 === wayPointCount)
                    {
                        rootView.mainView.get(0, false).mapComponent.displayItinerary(parseInt(jsonObj["id"]));
                        rootView.modal.visible = false;
                    }
                });
            }(idx));
        }
    }
}

function updateItineraryAndDisplay()
{
    console.log("TODO updateItinerary")

    rootView.mainView.get(0, false).mapComponent.displayItinerary(jsonObj["id"]);
    rootView.modal.visible = false;
}

function createItineraryAndDisplay()
{
    var currentIt = rootView.lamaSession.CURRENT_ITINERARY
    var startPoint = currentIt["departure"]
    var lastId = currentIt["destinations"].length - 1
    var arrivalPoint = currentIt["destinations"][lastId]
    var requestDeparture = startPoint["longitude"] + ', ' + startPoint["latitude"]
    var requestArrival = arrivalPoint["longitude"] + ', ' + arrivalPoint["latitude"]

    var waypointArray = [];
    if (lastId !== 0)
        for (var idx = 0; idx < lastId; ++idx)
        {
            var currentPoint = currentIt["destinations"][idx]
            waypointArray.push(currentPoint["longitude"] + ', ' + currentPoint["latitude"])
        }

    if (currentIt['name'] === null || currentIt['name'] === '')
        currentIt['name'] = "tmp_itinerary_" + ViewsLogic.getRandomString(8);

    //itineraryServices.abortPendingRequests()
    itineraryServices.createItinerary(currentIt['name'], requestDeparture, requestArrival, currentIt["favorite"] ? "true" : "false",
                    function(waypointArray)
    {
        return (function(statusCode, jsonStr)
        {
            console.log("CreateItinerary Response Status : " + statusCode);
            if (statusCode === 0)
            {
                var jsonObj = JSON.parse(jsonStr)
                var ItId = jsonObj["id"]
                console.log("CreateItinerary Response Id : " + ItId);
                rootView.lamaSession.CURRENT_ITINERARY['id'] = ItId;
                proceedToAddWayPoints(waypointArray)
            }
            else
            {
                rootView.Modal.title = "Error"
                rootView.Modal.message = "Unfortunatly the llama did not find his way"
                rootView.Modal.enableButton = true
                rootView.Modal.setLoadingState(false)
            }
        });
    }(waypointArray));
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
                    mainModal.message = "Sadly, an error occured (MAPVIEW_RESOLV_EXIST_IT_FAIL)"
                    mainModal.enableButton = true
                    mainModal.visible = true
                }
                updateItineraryAndDisplay()
            });
        }());
    else
        createItineraryAndDisplay();
}
