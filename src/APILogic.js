function isLatLong(str)
{
    var re = /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/;
    return str.match(re);
}

function geocode(address, then)
{
    var callback = function(then)
    {
        function callbackThen(results)
        {
            geolocator.geocodeFinished.disconnect(callbackThen);
            then(results.length > 0 ? results[0] : null);
        }
        return callbackThen;
    };

    geolocator.geocodeFinished.connect(callback(then));
    geolocator.geocode(address);
}

function reverse(coords, then)
{
    var callback = function(then)
    {
        function callbackThen(results)
        {
            geolocator.geocodeFinished.disconnect(callbackThen);
            then(results.length > 0 ? results[0] : null);
        }
        return callbackThen;
    };

    geolocator.geocodeFinished.connect(callback(then));
    geolocator.reverse(coords.x, coords.y);
}

function prepare(param, then)
{
    if (!param)
    {
        then(null);
        return;
    }

    if (!isLatLong(param))
    {
        var callback = function(then)
        {
            return function(obj)
            {
                if (!obj)
                {
                    then(null);
                    return;
                }
                then({ addressStr: obj.address, address: obj.latitude + ", " + obj.longitude });
            };
        };

        geocode(param, callback(then));
    }
    else
        then({ addressStr: param, address: param });
}

function finish(then)
{
    return function(status, jsonStr)
    {
        if (status !== 0)
        {
            console.log("Error: failed (" + status + "): " + jsonStr);
            then(false, "Error " + status + ": " + jsonStr);
            return;
        }

        var obj = {};

        try
        {
            if (jsonStr)
                obj = JSON.parse(jsonStr);
        }
        catch (e)
        {
            obj = {};
            console.log("Warning: cannot parse: " + jsonStr);
        }

        then(true, obj);
    };
}

function getItineraries(username, favorite, then)
{
    itineraryServices.getItineraries(
                "",
                username,
                (favorite ? (favorite === "true" ? "true" : "false") : ""),
                "",
                finish(then));
}

function getItinerary(itinerary, then)
{
    itineraryServices.getItinerary(
                itinerary,
                finish(then));
}

function createItinerary(departure, name, then)
{
    var callback = function(departure, name, then)
    {
        return function(obj)
        {
            if (!obj)
            {
                then(false, "Invalid location: " + departure);
                return;
            }

            itineraryServices.createItinerary(
                        name,
                        obj["address"],
                        obj["addressStr"],
                        "",
                        "",
                        "",
                        finish(then));
        }
    };

    prepare(departure, callback(departure, name, then));
}

function editItinerary(itinerary, departure, name, favorite, then)
{
    var callback = function(itinerary, departure, name, favorite, then)
    {
        return function(obj)
        {
            if (departure && !obj)
            {
                then(false, "Invalid location: " + departure);
                return;
            }

            itineraryServices.editItinerary(
                        itinerary,
                        name,
                        (obj ? obj["address"] : ""),
                        (obj ? obj["addressStr"] : ""),
                        (favorite ? (favorite === "true" ? "true" : "false") : ""),
                        finish(then));
        }
    };

    if (!departure)
    {
        (callback(itinerary, departure, name, favorite, then))(null);
        return;
    }

    prepare(departure, callback(itinerary, departure, name, favorite, then));
}

function addDestination(itinerary, position, destination, then)
{
    var callback = function(itinerary, position, destination, then)
    {
        return function(obj)
        {
            if (!obj)
            {
                then(false, "Invalid location: " + destination);
                return;
            }

            itineraryServices.addDestination(
                        itinerary,
                        obj["address"],
                        obj["addressStr"],
                        position >= 0 ? position : -1,
                        finish(then));
        }
    };

    prepare(destination, callback(itinerary, position, destination, then));
}

function editDestination(itinerary, position, destination, then)
{
    var callback = function(itinerary, position, destination, then)
    {
        return function(obj)
        {
            if (!obj)
            {
                then(false, "Invalid location: " + destination);
                return;
            }

            itineraryServices.editDestination(
                        itinerary,
                        position,
                        -1,
                        obj["address"],
                        obj["addressStr"],
                        finish(then));
        }
    };

    prepare(destination, callback(itinerary, position, destination, then));
}

function deleteDestination(itinerary, position, then)
{
    itineraryServices.deleteDestination(
                itinerary,
                position,
                finish(then));
}

function deleteItinerary(itinerary, then)
{
    itineraryServices.deleteItinerary(
                itinerary,
                finish(then));
}

function getUsers(search, sponsored, then)
{
    userServices.getUsers(
                search,
                (sponsored ? (sponsored === "true" ? "true" : "false") : ""),
                finish(then));
}

function getUser(username, then)
{
    userServices.getUser(
                username,
                finish(then));
}

function createUser(username, password, email, then)
{
    userServices.createUser(
                username,
                password,
                email,
                false,
                finish(then));
}

function editUser(username, password, email, sponsor, then)
{
    userServices.editUser(
                username,
                password,
                email,
                (sponsor ? (sponsor === "true" ? "true" : "false") : ""),
                finish(then));
}

function authenticate(username, password, then)
{
    userServices.createToken(
                username,
                password,
                finish(then));
}

function logout(then)
{
    userServices.deleteToken(finish(then));
}
