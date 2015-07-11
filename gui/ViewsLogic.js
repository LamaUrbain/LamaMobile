
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

function fillWaypoints(listModelId, itinerary)
{
    listModelId.clear();
    if ('departure' in itinerary)
        listModelId.append({waypointData: itinerary.departure})
    else
        listModelId.append({waypointData: {address: "Departure"}})

    var waypoints = itinerary.destinations;

    for (var idx = 0; idx < waypoints.length; ++idx)
        listModelId.append({waypointData: waypoints[idx]})
}

function getPtFromIndex(idx, itinerary)
{
    if (idx === 0)
        return (itinerary["departure"]);
    else if (idx > 0)
        return (itinerary["destinations"][idx - 1])
    return (null);
}
