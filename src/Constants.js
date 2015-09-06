var LAMA_YELLOW = "#F0C416";
var LAMA_ORANGE = "#CA653D";
var LAMA_BACKGROUND = Qt.lighter(LAMA_YELLOW, 1.5);
var LAMA_POINTSIZE = 20.0;

var LAMA_OSM_USERAGENT = "LamaUrbain"

var LAMA_BUS_RESSOURCE = "qrc:/Assets/Images/6.png";
var LAMA_TRAIN_RESSOURCE = "qrc:/Assets/Images/22.png";
var LAMA_CAR_RESSOURCE = "qrc:/Assets/Images/6.png";
var LAMA_ONFOOT_RESSOURCE = "qrc:/Assets/Images/27.png";
var LAMA_TRAM_RESSOURCE = "qrc:/Assets/Images/24.png";
var LAMA_BIKE_RESSOURCE = "qrc:/Assets/Images/18.png";
var LAMA_BACK_RESSOURSE = "qrc:/Assets/Images/9.png";
var LAMA_CROSS_RESSOURSE = "qrc:/Assets/Images/2.png";
var LAMA_SHARE_RESSOURCE = "qrc:/Assets/Images/20.png";
var LAMA_SAVE_RESSOURCE = "qrc:/Assets/Images/21.png";
var LAMA_SAVED_RESSOURCE = "qrc:/Assets/Images/21b.png";
var LAMA_ADD_RESSOURCE = "qrc:/Assets/Images/8.png";
var LAMA_DEPARTURE_RESSOURCE = "qrc:/Assets/Images/departure.png";
var LAMA_INDICATOR_RESSOURCE = "qrc:/Assets/Images/map_indicator.png";
var LAMA_ARRIVAL_RESSOURCE = "qrc:/Assets/Images/arrival.png";

var LAMA_MIN_INPUT_LENGTH = 2;
var LAMA_PASSWORD_RANDOM_LENGTH = LAMA_MIN_INPUT_LENGTH * 2;

var LAMA_BASE_ITINERARY_OBJ =
        {
            id: null,
            owner: '',
            name: '',
            creation: '',
            favorite: false,
            departure:
            {
                address: null,
                latitude: null,
                longitude: null
            },
            destinations:
            [

            ]
        };
