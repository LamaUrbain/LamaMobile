.pragma library // Statefull

var LAMA_USER_IS_LOGGED = false
var LAMA_USER_TOKEN = ""
var LAMA_USER_USERNAME = ""
var LAMA_USER_EMAIL = ""
var LAMA_USER_PASSWORD = ""
var LAMA_USER_AVATAR = ""

var LAMA_USER_CURRENT_ITINERARY = {}
var LAMA_USER_CURRENT_WAYPOINT_ID = -1
var LAMA_USER_CURRENT_WAYPOINT = {}
var LAMA_USER_KNOWN_ITINERARIES =
[
    {
        id: 1337,
        owner: 'sw3g b0y',
        name: 'From home to work',
        creation: '2015-03-31T08:00:00Z',
        favorite: true,
        departure:
        {
            address: '26 Rue du bailly',
            latitude: 2.355989,
            longitude: 48.912903
        },
        destinations:
        [
            {
                address: 'ARROW ECS',
                latitude: 2.256769,
                longitude: 48.893592
            }
        ]
    },
    {
        id: 1336,
        owner: 'sw3g b0y',
        name: 'Wrong itinerary',
        creation: '2015-03-31T08:00:00Z',
        favorite: false,
        departure:
        {
            address: 'Sex Shop',
            latitude: 2.355989,
            longitude: 48.912903
        },
        destinations:
        [
            {
                address: 'Dildo Playground',
                latitude: 2.256769,
                longitude: 48.893592
            }
        ]
    }
]
