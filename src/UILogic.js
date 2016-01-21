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
            {
                addr = destination.latitude + "," + destination.longitude;
            }
            if (addr)
            {
                rootView.currentItinerary.destinations.append({ address: addr });
                checkDistance(i == 0 ? rootView.currentItinerary.departure : rootView.currentItinerary.destinations[i - 1],
                            addr, destination.address ? destination.address : null)
            }
        }
    }
    if ("vehicle" in obj)
    {
        if (obj.vehicle == "0")
            rootView.currentItinerary.vehicle = "foot";
        else if (obj.vehicle == "1")
            rootView.currentItinerary.vehicle = "bicycle";
        else
            rootView.currentItinerary.vehicle = "motor_vehicle";
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
            || itinerary.vehicle != rootView.currentItinerary.vehicle
            || itinerary.favorite != rootView.currentItinerary.favorite)
    {
        var departure = itinerary.departure != rootView.currentItinerary.departure ? itinerary.departure : "";
        var favorite = itinerary.favorite != rootView.currentItinerary.favorite ? (itinerary.favorite ? "true" : "false") : "";
        var vehicle = itinerary.vehicle != rootView.currentItinerary.vehicle ? itinerary.vehicle : "";
        var editCallback = function(itinerary) { return function(obj) { destinationsStep(obj, 0, itinerary); } };
        Api.editItinerary(itinerary.id, departure, itinerary.name, vehicle, favorite, endRequest(editCallback(itinerary), false));
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
    Api.editItinerary(currentItinerary.id, address, null, null, null, endRequest(updateItinerary, true));
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
                Api.editItinerary(currentItinerary.id, obj.address, null, null, null, endRequest(updateItinerary, true));
            else
                Api.editDestination(currentItinerary.id, position - 1, obj.address, endRequest(updateItinerary, true));
        }
    };

    getMapAddress(coords, callback(position));
}

function reportEvent(username, begin, end, address)
{
    var callback = function(name, begin, end, address)
    {
        return function (obj)
        {
            console.log("reportEvent", obj)
            if (obj)
            {
                var latlong = obj["address"].split(", ")
                var lat = latlong[0]
                var long = latlong[1]

                console.log("reportEvent", obj["address"], lat, long)

                var position = obj["address"]
                console.log("reportEvent: position", position)

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
                console.log("geocoding failed.")
        }
    };

    console.log("reportEvent: address", address)
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

function showDistanceWarningModal(address, distance)
{
    if (rootView.modal.visible == true && rootView.modal.title === "Watchout !")
        address = "a few addresses of wich some are\n" +
                   " further than 20 Kms away"
    else
    {
        rootView.modal.title = "Watchout !";
        rootView.modal.loading = false;
        address = "an address ";
        if (address !== null && address.length > 0)
            address += ":\n" + address + "\n";
        else
            address += " has been found ";
        address += Math.round(distance) + "Kms away."
    }
    rootView.modal.message = "We found " + address + "\n"
                            + "You might want to give us additional informations \n"
                            + "for enhanced results.";
    rootView.modal.visible = true;
}

function getDistance(A_coords, B_coords)
{
    function toRad(deg) { return (deg * (Math.PI / 180)); }

    var dLat = toRad(B_coords.latitude - A_coords.latitude)
    var dLon = toRad(B_coords.longitude - A_coords.longitude)
    var ALat = toRad(A_coords.latitude);
    var BLat = toRad(B_coords.latitude);

    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(ALat) * Math.cos(BLat);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return (c * 6371); // 6371 = earth in km
}

function checkDistance(A, B, displayAddress, IsAddr_A, IsAddr_B)
{
    if (A == null || B == null)
        return;
    if (typeof(IsAddr_A) === "undefined")
        IsAddr_A = Api.isLatLong(A) === null
    if (typeof(IsAddr_B) === "undefined")
        IsAddr_B = Api.isLatLong(B) === null

    if (IsAddr_A || IsAddr_B)
    {
        var X = IsAddr_A ? A : B
        Api.geocode(X, function (result)
        {
            if (X == A && IsAddr_B)
                checkDistance(result, B, displayAddress, false, IsAddr_B)
            else if (X == B)
                checkDistance(A, result, displayAddress, IsAddr_A, false)
        });
    }
    else
    {
        var distance_km = getDistance(A, B);
        if (distance_km > 20)
            showDistanceWarningModal(typeof(displayAddress) === "undefined" ? null : displayAddress,
                                    distance_km);
    }
}
