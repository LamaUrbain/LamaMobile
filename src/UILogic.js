.import "APILogic.js" as Api

function startRequest()
{
    mainModal.loading = true;
    mainModal.visible = true;
}

function endRequest(then, hide)
{
    return function(success, obj)
    {
        if (!success)
        {
            rootView.modal.loading = false;
            rootView.modal.title = "Error";
            rootView.modal.message = obj;
            rootView.modal.visible = true;
        }
        else
        {
            if (hide)
                mainModal.visible = false;
            if (then)
                then(obj);
        }
    }
}

function updateItinerary(obj)
{
    if (!obj)
        return;

    rootView.currentItinerary.clear();

    if ("id" in obj)
    {
        var id = parseInt(obj["id"]);
        if (id >= 0)
            rootView.currentItinerary.id = parseInt(obj["id"]);
    }
    if ("owner" in obj && obj.owner)
    {
        rootView.currentItinerary.owner = obj.owner;
    }
    if ("name" in obj && obj.name)
    {
        rootView.currentItinerary.name = obj.name;
    }
    if ("favorite" in obj && obj.favorite)
    {
        rootView.currentItinerary.favorite = true;
    }
    if ("departure" in obj && obj.departure)
    {
        var departure = obj.departure;
        if (departure.address)
            rootView.currentItinerary.departure = departure.address;
        else if ("latitude" in departure && "longitude" in departure)
            rootView.currentItinerary.departure = departure.latitude + "," + departure.longitude;
    }
    if ("destinations" in obj && obj.destinations)
    {
        var destinations = obj.destinations;
        for (var i = 0; i < destinations.length; ++i)
        {
            var addr = null;
            var destination = destinations[i];
            if (destination.address)
                addr = destination.address;
            else if ("latitude" in destination && "longitude" in destination)
                addr = destination.latitude + "," + destination.longitude;
            if (addr)
                rootView.currentItinerary.destinations.append({ address: addr });
        }
    }

    mapView.mapComponent.displayItinerary(rootView.currentItinerary.id);
}

function clearItinerary()
{
    mapView.mapComponent.displayItinerary(-1);
    rootView.currentItinerary.clear();
}

function homeSearch(departure)
{
    startRequest();
    Api.createItinerary(departure, "", endRequest(updateItinerary, true));
}

function mainSearch(itinerary)
{
    startRequest();

    // Five steps:
    // 1) Edit what is necesary (departure, name and/or favorite)
    // 2) Edit destinations of 'currentItinerary' if necesary
    // 3) Add destinations if 'itinerary' has more destinations than 'currentItinerary'
    // 4) Remove destinations if 'itinerary' has less destinations than 'currentItinerary'
    // 5) Update itinerary if something has changed

    function destinationsStep(obj, index, itinerary)
    {
        var currentCount = rootView.currentItinerary.destinations.count;
        var itineraryCount = itinerary.destinations.length
        var destinationCallback = function(index, itinerary) {
            return function(obj) {
                destinationsStep(obj, index + 1, itinerary);
            }
        };

        // 2) Edit destinations of 'currentItinerary' if necessary
        if (index < currentCount && index < itineraryCount)
        {
            var address = itinerary.destinations[index].address;
            if (address != rootView.currentItinerary.destinations.get(index).address)
                Api.editDestination(itinerary.id, index, address, endRequest(destinationCallback(index, itinerary)));
            else
                destinationsStep(obj, index + 1, itinerary);
        }
        // 3) Add destinations if 'itinerary' has more destinations than 'currentItinerary'
        else if (index < itineraryCount)
            Api.addDestination(itinerary.id, -1, itinerary.destinations[index].address, endRequest(destinationCallback(index, itinerary)));
        // 4) Remove destinations if 'itinerary' has less destinations than 'currentItinerary'
        else if (index < currentCount)
            Api.deleteDestination(itinerary.id, index, endRequest(destinationCallback(index, itinerary)));
        // 5) Update itinerary if something has changed
        else
        {
            rootView.modal.visible = false;
            updateItinerary(obj);
            rootView.mainViewBack();
        }
    }

    // 1) Edit what is necesary (departure, name and/or favorite)
    if (itinerary.departure != rootView.currentItinerary.departure
            || itinerary.name != rootView.currentItinerary.name
            || itinerary.favorite != rootView.currentItinerary.favorite)
    {
        var departure = itinerary.departure != rootView.currentItinerary.departure ? itinerary.departure : "";
        var favorite = itinerary.favorite != rootView.currentItinerary.favorite ? (itinerary.favorite ? "true" : "false") : "";
        var editCallback = function(itinerary) { return function(obj) { destinationsStep(obj, 0, itinerary); } };
        Api.editItinerary(itinerary.id, departure, itinerary.name, favorite, endRequest(editCallback(itinerary), false));
    }
    else
        destinationsStep(null, 0, itinerary);
}

function displayItinerary(id)
{
    startRequest();
    Api.getItinerary(id, endRequest(updateItinerary, true));
}

function deleteItinerary(id, then)
{
    if (rootView.currentItinerary.id == id)
        clearItinerary();

    startRequest();
    Api.deleteItinerary(id, endRequest(then, true));
}

function getMapAddress(coords, then)
{
    startRequest();

    var callback = function(then)
    {
        return function(obj)
        {
            mainModal.visible = false;
            if (obj)
                then(obj);
        }
    };

    Api.reverse(Qt.point(coords.y, coords.x), callback(then));
}

function setMapDeparture(address)
{
    startRequest();
    Api.editItinerary(currentItinerary.id, address, null, null, endRequest(updateItinerary, true));
}

function addMapDestination(address)
{
    startRequest();

    if (currentItinerary.destinations.count > 0)
    {
        var position = currentItinerary.destinations.count - 1;
        Api.addDestination(currentItinerary.id, position, address, endRequest(updateItinerary, true));
    }
    else
        Api.addDestination(currentItinerary.id, -1, address, endRequest(updateItinerary, true));
}

function setMapDestination(address)
{
    startRequest();

    if (currentItinerary.destinations.count > 0)
    {
        var position = currentItinerary.destinations.count - 1;
        Api.editDestination(currentItinerary.id, position, address, endRequest(updateItinerary, true));
    }
    else
        Api.addDestination(currentItinerary.id, -1, address, endRequest(updateItinerary, true));
}

function moveMapDestination(position, coords)
{
    var callback = function(position)
    {
        return function(obj)
        {
            startRequest();

            if (position == 0)
                Api.editItinerary(currentItinerary.id, obj.address, null, null, endRequest(updateItinerary, true));
            else
                Api.editDestination(currentItinerary.id, position - 1, obj.address, endRequest(updateItinerary, true));
        }
    };

    getMapAddress(coords, callback(position));
}

function reportEvent(username, begin, end, position, address)
{
    var callback = function(name, begin, end, address)
    {
        return function (obj)
        {
            if (obj)
            {
                console.log(obj.latitude, obj.longitude)
                var position = JSON.toString({
                    longitude: obj.longitude,
                    latitude: obj.latitude
                })
                var callback = function(status, obj)
                {
                    if (!status)
                    {
                        console.log("event reporting failed")
                    }
                }

                Api.reportEvent(username, begin, end, position, address, callback)
            }
            else
                console.log("geocoging failed.")
        }
    };

    Api.prepare(address, callback(username, begin, end, address))
}

function displayEvent(events, parentMap)
{
    console.log("display", events.count, "events of model", events)
    for (var i = 0; i < events.count; ++i)
    {
        var event = events.get(i)

        if (event === undefined)
        {
            console.debug("events[",i,"] is undefined")
            continue;
        }

        var attrs = {
            coordinate: Qt.point(event.position.longitude, event.position.latitude)
        }

        console.debug("placing event", event.name, "at", event.position.latitude, ",", event.position.longitude)
        var component = Qt.createComponent("qrc:/Components/EventPoints.qml")
        component.createObject(parentMap, attrs)
    }
}
