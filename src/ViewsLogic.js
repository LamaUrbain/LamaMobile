
var MinLength = 2 // dont know how to get it from the other JS

function checkInput(nickname)
{
    return (nickname.length < MinLength)
}

function checkMail(mail)
{
   var at_Index = mail.indexOf('@')
   return (at_Index <= 0 || mail.lastIndexOf('.') < at_Index || mail.length < 6)
}

function checkPassword(pass, passConfirm)
{
    return (pass.length < MinLength * 2 || pass !== passConfirm);
}

function getRandomString(length)
{
    var text = "";
    var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-()[]";

    for( var i=0; i < length; i++ )
        text += possible.charAt(Math.floor(Math.random() * charset.length));

    return (text);
}

function _isItineraryValid(itinerary)
{
    return (itinerary !== null
        && "departure" in itinerary
        && "destinations" in itinerary);
}

function isValueAtKeyValid(obj, key)
{
    console.log(obj)
    return (obj !== null
            && key in obj
            && obj[key] !== null)
}

function getPtFromIndex(idx, itinerary)
{
    if (_isItineraryValid(itinerary))
    {
        if (idx === 0)
            return (itinerary["departure"]);
        else if (idx > 0 && itinerary["destinations"].length >= idx)
            return (itinerary["destinations"][idx - 1])
    }
    return (null);
}

function onItineraryCreateResponse(statusCode, jsonStr)
{
    mainModal.visible = false
    console.log("CreateItinerary Response : " + statusCode + '(' + (statusCode == 0) + ')');
    if (statusCode === 0)
    {
        var jsonObj = JSON.parse(jsonStr)
        console.log("CreateItinerary Response Id : " + jsonObj["id"]);
        mapView.mapComponent.displayItinerary(jsonObj["id"]);
    }
    else
        onIniteraryRequestFailure(statusCode, "Malheureusement le llama n'a pas trouvé de chemain")
}

function fillSponsors(listModel, knownSponsors)
{
    listModel.clear();

    for (var idx = 0; idx < knownSponsors.length; ++idx)
            listModel.append({sponsor: knownSponsors[idx]})
}

function fillFavorites(listModel, knownItineraries)
{
    listModel.clear();

    for (var idx = 0; idx < knownItineraries.length; ++idx)
        if (knownItineraries[idx]["favorite"] === true)
            listModel.append({itinerary: knownItineraries[idx]})
}

function fillWaypoints(listModelId, itinerary)
{
    listModelId.clear();
    if ('departure' in itinerary)
        listModelId.append({waypointData: itinerary.departure})
    else
    {
        listModelId.append({waypointData: {address: "Departure"}})
        return;
    }

    if ('destinations' in itinerary)
    {
        var waypoints = itinerary["destinations"];

        for (var idx = 0; idx < waypoints.length; ++idx)
            listModelId.append({waypointData: waypoints[idx]})
    }
}

function getIndexItineraryKnown(knownIts, newIt)
{
    if (!isValueAtKeyValid(newIt, "id"))
        newIt['id'] = -(Math.round(Date.now() / 1000) % 100000000)

    var exists = false;
    for (var idx = 0; idx < knownIts.length; ++idx)
        if (knownIts[idx]["id"] === newIt["id"])
            return (idx)
    return (-1);
}

function spawnDeparturePopOver(mapItem, x, y, message)
{
    spawnPopOver(mapItem, x, y, message, "departure")
}

function spawnWaypointPopOver(mapItem, x, y, message)
{
    spawnPopOver(mapItem, x, y, message, "waypoint")
}

function spawnArrivalPopOver(mapItem, x, y, message)
{
    spawnPopOver(mapItem, x, y, message, "arrival")
}

function spawnPopOver(mapItem, x, y, message, popType)
{
    var coord = mapItem.toCoordinate(Qt.point(x, y));
    if (coord.isValid === false)
        console.log("Error converting points to coordinate");
    else
    {
        var component = Qt.createComponent( "qrc:/Components/PopOver.qml" );
        if(component.status !== Component.Ready)
            console.debug("Error:"
                          + (component.status === Component.Error ? component.errorString() : "Component failure"));
        else
        {
            var pop = component.createObject(mapItem,
                                             {
                                                 "message": "loading",
                                                 "coordinate": coord,
                                                 "popOverType": popType,
                                             });

            var geocode = Qt.createQmlObject("import QtLocation 5.3; GeocodeModel {}", pop)
            geocode.plugin = map.plugin;
            geocode.query = coord;
            geocode.update();

            geocode.locationsChanged.connect(
                        function ()
                        {
                            if (geocode.status !== GeocodeModel.Ready)
                            {
                                console.log("geomodel error: "+ geocode.errorString);
                                return null;
                            }
                            if (geocode.count < 1)
                            {
                                console.log("not enought returned values ?");
                                return null;
                            }

                            var loc = geocode.get(0);

                            console.log("geocode model updated, got %1 response".arg(geocode.count));
                            console.log("geocode: steet: %1".arg(loc.address.text))

                            if (loc.address === null)
                            {
                                console.log("geocoding returned null result.");
                                pop.destroy();
                                return null;
                            }

                            console.log("geocoding sucessfull, seting address and add waypoint to query");
                            pop.setAddress(loc.address);
                            mainRouteQuery.addWaypoint(pop.coordinate);
                            mainRoute.update();
                        });

            if (pop === null)
                console.log("Error creating object ;)");
            mapItem.addMapItem(pop);
            return (pop)
        }
    }
    return (null);
}

function spawnModal(title, message)
{
    mainModal.title = title
    mainModal.message = message
    mainModal.visible = true
}

function spawnModalWithSource(title, source)
{
    mainModal.title = title
    mainModal.modalSourceComponent = source
    mainModal.visible = true
}
