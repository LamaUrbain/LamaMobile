var LAMA_YELLOW = "#F3D046";
var LAMA_ORANGE = "#EA7B3D";
var LAMA_BORDER_COLOR = "#F0C416"
var LAMA_BORDER_COLOR2 = "#DC5E18"
var LAMA_BACKGROUND = "#CFFFFFFF";
var LAMA_BACKGROUND2 = "#EAFFFFFF";
var LAMA_FONTCOLOR = "#555"
var LAMA_PIXELSIZE = 26;
var LAMA_PIXELSIZE_BIG = 44;
var LAMA_PIXELSIZE_MEDIUM = 20;
var LAMA_PIXELSIZE_SMALL = 16;

var LAMA_OSM_USERAGENT = "LamaUrbain"
var LAMA_URL_FACEBOOK_SHARE = 'https://www.facebook.com/sharer/sharer.php?u=http%3A//lamaurba.in/itinerary/'
var LAMA_URL_TWITTER_SHARE = 'http://twitter.com/home/?status=Check%20out%20out%20this%20itinerary%21%20http%3A//lamaurba.in/itinerary/'
var LAMA_URL_TWITTER_HASHTAGS = '%20%23openstreetmap%20%40lama_urbain'
var LAMA_DEFAULT_URL = "http://lamaurba.in/"
var LAMA_GRAVATAR_URL = "http://www.gravatar.com/avatar/"
var LAMA_GRAVATAR_SIZE = 256

var LAMA_LOGO = "qrc:/Assets/Images/logo_small.png"
var LAMA_HOME = "qrc:/Assets/Images/shadow_small.png"
var LAMA_MENU_RESSOURCE = "qrc:/Assets/Images/13.png"
var LAMA_ITINERARY_RESSOURCE = "qrc:/Assets/Images/10.png"
var LAMA_SEARCH_RESSOURCE = "qrc:/Assets/Images/19.png"
var LAMA_SIGNUP_RESSOURCE = "qrc:/Assets/Images/1.png"
var LAMA_SIGNIN_RESSOURCE = "qrc:/Assets/Images/11.png"
var LAMA_LOGOUT_RESSOURCE = "qrc:/Assets/Images/12.png"
var LAMA_PROFILE_RESSOURCE = "qrc:/Assets/Images/26.png"
var LAMA_FAVORITE_RESSOURCE = "qrc:/Assets/Images/21.png";
var LAMA_SETTINGS_RESSOURCE = "qrc:/Assets/Images/23.png";
var LAMA_SPONSORS_RESSOURCE = "qrc:/Assets/Images/5.png";
var LAMA_INCIDENT_RESSOURCE = "qrc:/Assets/Images/17.png";
var LAMA_CONTACT_RESSOURCE = "qrc:/Assets/Images/0.png";
var LAMA_ADDRESS_RESSOURCE = "qrc:/Assets/Images/16.png";
var LAMA_HELP_RESSOURCE = "qrc:/Assets/Images/7.png";
var LAMA_BACK_RESSOURSE = "qrc:/Assets/Images/9.png";
var LAMA_SHARE_RESSOURCE = "qrc:/Assets/Images/20.png";
var LAMA_FACEBOOK_RESSOURCE = "qrc:/Assets/Images/4.png";
var LAMA_TWITTER_RESSOURCE = "qrc:/Assets/Images/25.png";
var LAMA_SAVE_RESSOURCE = "qrc:/Assets/Images/21.png";
var LAMA_SAVED_RESSOURCE = "qrc:/Assets/Images/21b.png";
var LAMA_SEE_RESSOURCE = "qrc:/Assets/Images/3.png";
var LAMA_ARROW_RESSOURCE = "qrc:/Assets/Images/arrow.png";
var LAMA_PROFILE_RESSOURCE = "qrc:/Assets/Images/26.png";
var LAMA_CROSS_RESSOURSE = "qrc:/Assets/Images/2.png";
var LAMA_ADD_RESSOURCE = "qrc:/Assets/Images/8.png";
var LAMA_CURVEDARROW_RESSOURCE = "qrc:/Assets/Images/28.png";
var LAMA_DEPARTURE_RESSOURCE = "qrc:/Assets/Images/departure.png";
var LAMA_INDICATOR_RESSOURCE = "qrc:/Assets/Images/map_indicator.png";
var LAMA_ARRIVAL_RESSOURCE = "qrc:/Assets/Images/arrival.png";
var LAMA_FOOT_RESSOURCE = "qrc:/Assets/Images/27.png";
var LAMA_BICYCLE_RESSOURCE = "qrc:/Assets/Images/18.png";
var LAMA_MOTOR_VEHICLE_RESSOURCE = "qrc:/Assets/Images/6.png";

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
