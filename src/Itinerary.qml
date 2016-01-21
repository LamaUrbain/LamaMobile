import QtQuick 2.5

QtObject {
    id: itineraryObj

    property int id: -1
    property var owner: null
    property string name: ""
    property var creation: null
    property bool favorite: false
    property string departure: ""
    property string vehicle: "foot"
    property ListModel destinations: ListModel {}

    function clear()
    {
        itineraryObj.id = -1;
        itineraryObj.owner = null;
        itineraryObj.name = "";
        itineraryObj.creation = null;
        itineraryObj.favorite = false;
        itineraryObj.departure = "";
        destinations.clear();
    }

    function copy(other)
    {
        itineraryObj.id = other.id;
        itineraryObj.owner = other.owner;
        itineraryObj.name = other.name;
        itineraryObj.creation = other.creation;
        itineraryObj.favorite = other.favorite;
        itineraryObj.vehicle = other.vehicle;
        itineraryObj.departure = other.departure;

        destinations.clear();

        for (var i = 0; i < other.destinations.count; ++i)
            destinations.append({ address: other.destinations.get(i).address });
    }

    function toObject()
    {
        var array = new Array;
        for (var i = 0; i < destinations.count; ++i)
            array.push({ address: destinations.get(i).address });

        return {
            id: itineraryObj.id,
            owner: itineraryObj.owner,
            name: itineraryObj.name,
            creation: itineraryObj.creation,
            favorite: itineraryObj.favorite,
            departure: itineraryObj.departure,
            vehicle: itineraryObj.vehicle,
            destinations: array
        };
    }
}
