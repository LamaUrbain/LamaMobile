.pragma library // Statefull
.import "APILogic.js" as APILogic
.import QtQuick.LocalStorage 2.0 as Sql

var LAMA_LOCALDB_NAME = "LamaLocalDB"
var LAMA_LOCALDB_TABLENAME = "USER"
var LAMA_LOCALDB_VERSION = "1.0"
var LAMA_LOCALDB_DESC = "The llama urbain DB"
var LAMA_LOCALDB_ESIZE = 1 * 1024 * 1024

var LAMA_SESSION =
{
    IS_LOGGED: false,
    TOKEN: null,
    USERNAME: null,
    EMAIL: null,
    PASSWORD: null,
    AVATAR: null,
    CURRENT_ITINERARY: {},
    CURRENT_WAYPOINT_ID: -1,
    CURRENT_WAYPOINT: {},
    KNOWN_SPONSORS:
    [
        {
            name: "McDo",
        },
        {
            name: "KFC",
        }
    ],
    KNOWN_ITINERARIES:
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
}

var mainModal;

function createDB(db)
{
    if (db.version === '')
        db.changeVersion("", LAMA_LOCALDB_VERSION);
    var columns =
            [
                {
                    name: "id",
                    type: "INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE"
                },
                {
                    name: "user_name",
                    type: "TEXT"
                },
                {
                    name: "user_password",
                    type: "TEXT"
                },
                {
                    name: "user_email",
                    type: "TEXT"
                },
                {
                    name: "user_avatar",
                    type: "TEXT"
                },
                {
                    name: "user_knownroutes",
                    type: "TEXT"
                },
            ]

    var sqlStr = "CREATE TABLE IF NOT EXISTS " + LAMA_LOCALDB_TABLENAME + "(";
    for (var idx = 0; idx < columns.length;)
        sqlStr += columns[idx].name + " " + columns[idx].type + (((++idx) < columns.length) ? ", " : '');
    sqlStr += ");"
    db.transaction(function (tx)
    {
        console.log("Table creation...")
        tx.executeSql(sqlStr)
        console.log("Table created !")
    });
    console.log("Database created !")
    return (db);
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

function checkAndLoadFromSavedData(Session)
{
    var db = openDb()

    db.transaction(
        function(tx)
        {
            var query = tx.executeSql('SELECT * FROM ' + LAMA_LOCALDB_TABLENAME + ';');
            if (query.rows.length > 0)
            {
                var row = query.rows.item(0);
                if (row.user_name.length > 0)
                    Session.USERNAME = row.user_name.replace(/'/g, '"')
                if (row.user_password.length > 0)
                    Session.PASSWORD = row.user_password.replace(/'/g, '"')
                if (row.user_knownroutes.length > 0)
                    Session.KNOWN_ITINERARIES = JSON.parse(row.user_knownroutes.replace(/'/g, '"'))
                if (row.user_email.length > 0)
                    Session.EMAIL = row.user_email.replace(/'/g, '"')
                if (row.user_avatar.length > 0)
                    Session.AVATAR = row.user_avatar.replace(/'/g, '"')
                console.log("Offline data loaded !")
            }
            else
                console.log("Unable to load offline data...")
        }
    )
}

function deleteCurrentToken(Session)
{
    APILogic.requestAPI("DELETE", "/tokens/" + Session.TOKEN + "/", null, null, null)
    Session.TOKEN = ""
    Session.IS_LOGGED = false
}

function deleteSavedData(Session)
{
    Session.EMAIL = ""
    Session.AVATAR = ""
    Session.CURRENT_ITINERARY = {}
    Session.CURRENT_WAYPOINT_ID = -1
    Session.CURRENT_WAYPOINT = {}
    Session.KNOWN_ITINERARIES = []

    var db = openDb()

    db.transaction(function (tx)
    { tx.executeSql("DELETE FROM " + LAMA_LOCALDB_TABLENAME); } )
}

function saveSessionState(Session)
{
    if (Session === null || typeof(Session) === "undefined")
        throw ("What the fuck man");
    var db = openDb()
    db.transaction(function (tx)
    {
        var columns =
                [
                    {
                        name: "user_name",
                        value: Session.USERNAME
                    },
                    {
                        name: "user_password",
                        value: Session.PASSWORD
                    },
                    {
                        name: "user_email",
                        value: Session.EMAIL
                    },
                    {
                        name: "user_avatar",
                        value: Session.AVATAR
                    },
                    {
                        name: "user_knownroutes",
                        value: JSON.stringify(Session.KNOWN_ITINERARIES)
                    },
                ]
        var sqlStr = "INSERT OR REPLACE INTO USER (id, user_name, user_password, user_email, user_avatar, user_knownroutes) VALUES (1, ";
        var idx = 0;
        var val = '';
        while (idx < columns.length)
        {
            if (columns[idx].value !== null)
                val = columns[idx].value.replace(/"/g, "'")
            sqlStr += '"' + val + (((++idx) < columns.length) ? '", ' : '"')
            val = ''
        }
        sqlStr += ');';

        if (tx.executeSql(sqlStr).rowsAffected > 0)
            console.log("Offline data saved !")
        else
            console.log("Could not save offline data !")
        } );
}

function tryLogin(Session, clearPreviousData)
{
    if (Session.TOKEN !== null && Session.TOKEN.length > 0)
        deleteCurrentToken(Session)

    if (clearPreviousData)
        deleteSavedData(Session)
    else
        checkAndLoadFromSavedData(Session)

    if (Session.USERNAME === null ||
        Session.PASSWORD === null)
    {
        Session.USERNAME = null // Paranoia
        Session.PASSWORD = null // Paranoia
        return;
    }

    loginAndCreateToken();
}

function loginAndCreateToken(Session, callback)
{
    userServices.createToken(Session.USERNAME, Session.PASSWORD, function (success, userInfos)
    {
        if (success === false || userInfos === null)
        {
            Session.USERNAME = null
            Session.PASSWORD = null
            mainModal.title = "No internet connexion"
            mainModal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application."
            mainModal.setLoadingState(false)
            mainModal.enableButton = true
        }
        else
        {
            Session.IS_LOGGED = true
            Session.TOKEN = userInfos.token
            Session.IS_LOGGED = true
            loadItineraries(Session)
            getFurtherUserDetails(Session)
        }
    })
}

function getFurtherUserDetails(Session)
{
    //EMAIL = userInfos.email
    //AVATAR = userInfos.avatar
    //saveSessionState()
}

function loadItineraries(Session)
{
    itineraryServices.getItineraries(null, Session.USERNAME, true, null, function (success, userRoutes)
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
            Session.KNOWN_ITINERARIES = userRoutes
            mainModal.message = "You've successfully logged in !"
            mainModal.setLoadingState(false)
            mainModal.enableButton = true
            saveSessionState()
        }
    }, null)

}
