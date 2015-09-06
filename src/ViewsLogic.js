.import QtQml 2.2 as Qml

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
    var possibleChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-()[]";

    for( var i=0; i < length; i++ )
        text += possibleChars.charAt(Math.floor(Math.random() * possibleChars.length));

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

    for (var mult = 0; mult < 10; ++mult)
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
        listModelId.append({waypointData: {address: "Departure", latitude: null, longitude: null}})
        return;
    }

    if ('destinations' in itinerary)
    {
        var waypoints = itinerary["destinations"];

        for (var idx = 0; idx < waypoints.length; ++idx)
            listModelId.append({waypointData: waypoints[idx]})
    }
}

function getAddressPlaceholder(latitude, longitude)
{
    if (latitude && longitude)
        return longitude + ", " + latitude;
    return "Departure";
}

function getIndexItineraryKnown(knownIts, newIt)
{
    if (!isValueAtKeyValid(newIt, "id"))
        return (-1);

    var exists = false;
    for (var idx = 0; idx < knownIts.length; ++idx)
        if (knownIts[idx]["id"] === newIt["id"])
            return (idx)
    return (-1);
}

function spawnDeparturePopOver(mapItem, coord, message)
{
    spawnPopOver(mapItem, coord, message, "departure")
}

function spawnWaypointPopOver(mapItem, coord, message)
{
    spawnPopOver(mapItem, coord, message, "waypoint")
}

function spawnArrivalPopOver(mapItem, coord, message)
{
    spawnPopOver(mapItem, coord, message, "arrival")
}

function spawnPopOver(mapItem, coord, message, type)
{
    var cp = Qt.createComponent( "qrc:/Components/PopOver.qml" );
    if(cp.status !== Qml.Component.Ready)
        console.log("Error:"
                    + (cp.status === Qml.Component.Error ? cp.errorString() : "Component failure"));
    else
    {
        var pop = cp.createObject(mapItem,
                                         {
                                             "message": message,
                                             "coordinate": coord,
                                             "popOverType": type
                                         });

        if (pop === null)
            console.log("Error creating object ;)");
        return (pop)
    }
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

function fillHistory(model, limit)
{
    var db = Session.openDb()

    db.readTransaction(function (tx) {
        var tr = "SELECT HISTORY.history_term from HISTORY ORDER BY HISTORY.history_datetime DESC LIMIT ?;";
        var rq = tx.executeSql(tr, [limit]);

        model.clear()
        for (var i = 0; i < rq.rows.length; ++i)
        {
            var row = rq.rows.item(i)
            console.debug("[%1/%2] history: ".arg(i + 1).arg(rq.rows.length), row.history_term)
            model.append(row)
        }
    })
}

function fillHistoryFiltered(model, pattern, limit)
{
    var db = Session.openDb()

    db.readTransaction(function (tx) {
        var tr = 'SELECT HISTORY.history_term from HISTORY WHERE HISTORY.history_term LIKE ? ORDER BY HISTORY.history_datetime DESC LIMIT ?;'
        var rq = tx.executeSql(tr, ["%%1%".arg(pattern), limit]);

        model.clear()
        for (var i = 0; i < rq.rows.length; ++i)
        {
            var row = rq.rows.item(i)
            console.debug("[%1/%2] history: ".arg(i + 1).arg(rq.rows.length), row.history_term)
            model.append(row)
        }
    })
}


function addToHistory(term)
{
    var db = Session.openDb()

    db.transaction(function (tx){
        var tr = "INSERT OR REPLACE INTO HISTORY (history_term, history_datetime) VALUES (?, datetime('now'));";
        tx.executeSql(tr, [term]);
    })
}
