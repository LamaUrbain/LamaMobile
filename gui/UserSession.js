.pragma library // Statefull

var LAMA_USER_IS_LOGGED = false
var LAMA_USER_TOKEN = ""
var LAMA_USER_USERNAME = ""
var LAMA_USER_EMAIL = ""
var LAMA_USER_PASSWORD = ""
var LAMA_USER_PROFILEPICTURE = ""

var LAMA_USER_FAVORITE_INTINERARIES = []
//var LAMA_USER_CURRENT_INITNERARY = {}
var LAMA_USER_CURRENT_WAYPOINT_ID = -1
var LAMA_USER_CURRENT_WAYPOINT = {}

var LAMA_USER_CURRENT_ITINERARY = // DEBUG
{
  id: 4,
  owner: 'john',
  name: 'From home to school',
  creation: '2015-03-31T08:00:00Z',
  favorite: false,
  departure: {
    address: '12 rue de la convention, 94270 Le Kremlin-Bicêtre',
    latitude: 2.3488000,
    longitude: 48.8534100
  },
  destinations: [
    {
      address: 'Confin de l\'espace',
      latitude: 45.6344860,
      longitude: 47.2334300
    }
  ]
}
