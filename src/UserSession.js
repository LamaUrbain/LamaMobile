.pragma library // Statefull
.import "APILogic.js" as APILogic
.import QtQuick.LocalStorage 2.0 as Sql

var LAMA_USER_IS_LOGGED = false
var LAMA_USER_TOKEN = null
var LAMA_USER_USERNAME = null
var LAMA_USER_EMAIL = null
var LAMA_USER_PASSWORD = null
var LAMA_USER_AVATAR = null

var LAMA_LOCALDB_NAME = "LamaLocalDB"
var LAMA_LOCALDB_TABLENAME = "USER"
var LAMA_LOCALDB_VERSION = "2.0"
var LAMA_LOCALDB_DESC = "The llama urbain DB"
var LAMA_LOCALDB_ESIZE = 1000000

var LAMA_USER_CURRENT_ITINERARY = {}
var LAMA_USER_CURRENT_WAYPOINT_ID = -1
var LAMA_USER_CURRENT_WAYPOINT = {}
var LAMA_USER_KNOWN_ITINERARIES =
[
    {
        id: -1,
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

var LAMA_USER_KNOWN_SPONSORS = [
            {
                name: "McDo",
            },
            {
                name: "KFC",
            }
]

var mainModal;

function createDB(db)
{
    db.changeVersion("", LAMA_LOCALDB_VERSION);
    var columns =
            [
                {
                    name: "user_name",
                    type: "TEXT NOT NULL"
                },
                {
                    name: "user_password",
                    type: "TEXT"
                },
                {
                    name: "user_email",
                    type: "TEXT" // NOT NULL"
                },
                {
                    name: "user_avatar",
                    type: "TEXT"
                },
                {
                    name: "user_knownroutes",
                    type: "TEXT NOT NULL"
                },
            ]

    var sqlStr = "CREATE TABLE IF NOT EXISTS " + LAMA_LOCALDB_TABLENAME + "(";
    for (var idx = 0; idx < columns.length;)
        sqlStr += columns[idx].name + " " + columns[idx].type + (((++idx) < columns.length) ? ", " : '');
    sqlStr += ")"

    db.transaction(function (tx)
    {
        tx.executeSql(sqlStr)
        if (tx.executeSql("SELECT COUNT(user_name) FROM " + LAMA_LOCALDB_TABLENAME).rows.length < 1)
            tx.executeSql("INSERT INTO " + LAMA_LOCALDB_TABLENAME
                      + " VALUES ('', NULL, '', NULL, '[]')")
    });
}

function openDb()
{
    var db = Sql.LocalStorage.openDatabaseSync(LAMA_LOCALDB_NAME,
                                         "",//LAMA_LOCALDB_VERSION,
                                         LAMA_LOCALDB_DESC,
                                         LAMA_LOCALDB_ESIZE,
                                         createDB);
    return (db);
}

function checkAndFillFromSavedData()
{
    var db = openDb()

    db.transaction(
        function(tx)
        {
            var data = tx.executeSql('SELECT * FROM ' + LAMA_LOCALDB_TABLENAME + ' LIMIT 1');
            if (data.rows.length > 0)
            {
                var row = data.rows.item(0);
                LAMA_USER_USERNAME = row.user_name.replace(/'/g, '"')
                LAMA_USER_PASSWORD = row.user_password.replace(/'/g, '"')
                LAMA_USER_KNOWN_ITINERARIES = JSON.parse(row.user_knownroutes.replace(/'/g, '"'))
                if (row.user_email !== null)
                    LAMA_USER_EMAIL = row.user_email.replace(/'/g, '"')
                if (row.user_avatar !== null)
                    LAMA_USER_AVATAR = row.user_avatar.replace(/'/g, '"')
            }
        }
    )
}

function deleteCurrentToken()
{
    APILogic.requestAPI("DELETE", "/tokens/" + LAMA_USER_TOKEN + "/", null, null, null)
    LAMA_USER_TOKEN = ""
    LAMA_USER_IS_LOGGED = false
}

function deleteSavedData()
{
    LAMA_USER_EMAIL = ""
    LAMA_USER_AVATAR = ""
    LAMA_USER_CURRENT_ITINERARY = {}
    LAMA_USER_CURRENT_WAYPOINT_ID = -1
    LAMA_USER_CURRENT_WAYPOINT = {}
    LAMA_USER_KNOWN_ITINERARIES = []

    var db = openDb()

    db.transaction(function (tx)
    { tx.executeSql("DELETE FROM " + LAMA_LOCALDB_TABLENAME); } )
}

function saveCurrentSessionState()
{
    var db = openDb()
    db.transaction(function (tx)
    {
        var columns =
                [
                    {
                        name: "user_name",
                        value: LAMA_USER_USERNAME
                    },
                    {
                        name: "user_password",
                        value: LAMA_USER_PASSWORD
                    },
                    {
                        name: "user_email",
                        value: LAMA_USER_EMAIL
                    },
                    {
                        name: "user_avatar",
                        value: LAMA_USER_AVATAR
                    },
                    {
                        name: "user_knownroutes",
                        value: JSON.stringify(LAMA_USER_KNOWN_ITINERARIES)
                    },
                ]
        var sqlStr = "UPDATE " + LAMA_LOCALDB_TABLENAME + " SET "
        for (var idx = 0; idx < columns.length;)
            if (columns[idx].value !== null)
                sqlStr += columns[idx].name + ' = "' + columns[idx].value.replace(/"/g, "'") + (((++idx) < columns.length) ? '", ' : '"')
            else
                ++idx;
        console.log(sqlStr);
        tx.executeSql(sqlStr);
    } )
}

function tryLogin(clearPreviousData)
{
    if (LAMA_USER_TOKEN != null && LAMA_USER_TOKEN.length > 0)
        deleteCurrentToken()

    if (clearPreviousData)
        deleteSavedData()
    else
        checkAndFillFromSavedData()

    if (LAMA_USER_USERNAME === null ||
        LAMA_USER_PASSWORD === null)
    {
        LAMA_USER_USERNAME = null // Paranoia
        LAMA_USER_PASSWORD = null // Paranoia
        return;
    }

    loginAndCreateToken();
}

function loginAndCreateToken(callback)
{
    userServices.createToken(LAMA_USER_USERNAME, LAMA_USER_PASSWORD, function (success, userInfos)
    {
        if (success === false || userInfos === null)
        {
            LAMA_USER_USERNAME = null
            LAMA_USER_PASSWORD = null
            mainModal.title = "No internet connexion"
            mainModal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application."
            mainModal.setLoadingState(false)
            mainModal.enableButton = true
        }
        else
        {
            LAMA_USER_IS_LOGGED = true
            LAMA_USER_TOKEN = userInfos.token
            LAMA_USER_IS_LOGGED = true
            loadItineraries()
            getFurtherUserDetails()
        }
    })
}

function getFurtherUserDetails()
{
    //LAMA_USER_EMAIL = userInfos.email
    //LAMA_USER_AVATAR = userInfos.avatar
    //saveCurrentSessionState()
}

function loadItineraries()
{
    itineraryServices.getItineraries(null, LAMA_USER_USERNAME, true, null, function (success, userRoutes)
    {
        if (success === false || userRoutes === null)
        {
            mainModal.title = "No stable internet connexion"
            mainModal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application.\n\n"
                                + "We've been able to connect you but not gather your settings."
            mainModal.setLoadingState(false)
            mainModal.enableButton = true
        }
        else
        {
            LAMA_USER_KNOWN_ITINERARIES = userRoutes
            mainModal.message = "You've successfully logged in !"
            mainModal.setLoadingState(false)
            mainModal.enableButton = true
            saveCurrentSessionState()
        }
    }, null)

}
