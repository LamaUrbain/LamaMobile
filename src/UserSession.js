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
            logo: "http://img2.wikia.nocookie.net/__cb20110404033201/happymeal/images/1/13/McDonald's_logo.png",
        },
        {
            name: "KFC",
            logo: "http://www.pocketnews.com.my/wp-content/uploads/2014/10/KFC_logo.jpg",
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
                address: null,
                latitude: 48.912903,
                longitude: 2.355989
            },
            destinations:
            [
                {
                    address: null,
                    latitude: 48.893592,
                    longitude: 2.256769
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
                address: null,
                latitude: 48.912903,
                longitude: 2.355989
            },
            destinations:
            [
                {
                    address: null,
                    latitude: 48.893592,
                    longitude: 2.256769
                }
            ]
        }
    ]
}

function bootstrap_user(tx) {
    tx.executeSql(""
                  + "CREATE TABLE IF NOT EXISTS USER ("
                      + "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                      + "user_name TEXT,"
                      + "user_passwod TEXT,"
                      + "user_email TEXT,"
                      + "user_avatar TEXT,"
                      + "user_knownroutes TEXT"
                  + ");")
}

function bootstrap_history(tx) {
    tx.executeSql(""
                  + "CREATE TABLE IF NOT EXISTS HISTORY ("
                      + "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                      + "history_term TEXT,"
                      + "history_datetime TEXT"
                  + ");")
}


function createDBCallback(db)
{
    if (db.version === '')
        db.changeVersion("", LAMA_LOCALDB_VERSION);

    db.transaction(function (tx)
    {
        console.log("bootstraping db")
        var tables = [bootstrap_user, bootstrap_history]
        for (var i = 0; i < tables.length; ++i)
        {
            console.log("[%1/%2]".arg(i + 1).arg(tables.length), tables[i].name)
            tables[i](tx)
        }
        console.log("database bootstraped")
    });
    return (db);
}

var LAMA_DB_DESCRIPTOR = undefined

function openDb()
{
    if (LAMA_DB_DESCRIPTOR === undefined)
    {
        LAMA_DB_DESCRIPTOR =
                Sql.LocalStorage.openDatabaseSync(LAMA_LOCALDB_NAME,
                                                  "",//LAMA_LOCALDB_VERSION,
                                                  LAMA_LOCALDB_DESC,
                                                  LAMA_LOCALDB_ESIZE,
                                                  createDBCallback);
    }
    return LAMA_DB_DESCRIPTOR;
}

function checkAndLoadFromSavedData()
{
    var db = openDb()

    db.transaction(
        function(tx)
        {
            var query = tx.executeSql("SELECT * FROM " + LAMA_LOCALDB_TABLENAME + ";");
            if (query.rows.length > 0)
            {
                var row = query.rows.item(0);
                if (row.user_name.length > 0)
                    rootView.lamaSession.USERNAME = row.user_name.replace(/'/g, '"')
                if (row.user_password.length > 0)
                    rootView.lamaSession.PASSWORD = row.user_password.replace(/'/g, '"')
                if (row.user_knownroutes.length > 0)
                    rootView.lamaSession.KNOWN_ITINERARIES = JSON.parse(row.user_knownroutes.replace(/'/g, '"'))
                if (row.user_email.length > 0)
                    rootView.lamaSession.EMAIL = row.user_email.replace(/'/g, '"')
                if (row.user_avatar.length > 0)
                    rootView.lamaSession.AVATAR = row.user_avatar.replace(/'/g, '"')
                console.log("Offline data loaded !")
            }
            else
                console.log("Unable to load offline data...")
        }
    )
}

function deleteCurrentToken()
{
    userServices.deleteToken(null)
    rootView.lamaSession.TOKEN = ""
    rootView.lamaSession.IS_LOGGED = false
}

function deleteSavedData()
{
    rootView.lamaSession.EMAIL = ""
    rootView.lamaSession.AVATAR = ""
    rootView.lamaSession.CURRENT_ITINERARY = {}
    rootView.lamaSession.CURRENT_WAYPOINT_ID = -1
    rootView.lamaSession.CURRENT_WAYPOINT = {}
    rootView.lamaSession.KNOWN_ITINERARIES = []

    var db = openDb()

    db.transaction(function (tx)
    { tx.executeSql("DELETE FROM " + LAMA_LOCALDB_TABLENAME); } )
}

function saveSessionState()
{
    var db = openDb()
    db.transaction(function (tx)
    {
        var columns =
                [
                    {
                        name: "user_name",
                        value: rootView.lamaSession.USERNAME
                    },
                    {
                        name: "user_password",
                        value: rootView.lamaSession.PASSWORD
                    },
                    {
                        name: "user_email",
                        value: rootView.lamaSession.EMAIL
                    },
                    {
                        name: "user_avatar",
                        value: rootView.lamaSession.AVATAR
                    },
                    {
                        name: "user_knownroutes",
                        value: JSON.stringify(rootView.lamaSession.KNOWN_ITINERARIES)
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

function tryLogin(clearPreviousData)
{
    if (rootView.lamaSession.TOKEN !== null &&
        rootView.lamaSession.TOKEN.length > 0)
        deleteCurrentToken()

    if (clearPreviousData)
        deleteSavedData()
    else
        checkAndLoadFromSavedData()

    if (rootView.lamaSession.USERNAME === null ||
        rootView.lamaSession.PASSWORD === null)
    {
        rootView.lamaSession.USERNAME = null // Paranoia
        rootView.lamaSession.PASSWORD = null // Paranoia
        return;
    }

    loginAndCreateToken(rootView);
}

function loginAndCreateToken(rootView, callback)
{
    userServices.createToken(rootView.lamaSession.USERNAME, rootView.lamaSession.PASSWORD, function (success, userInfos)
    {
        if (success === false || userInfos === null)
        {
            rootView.lamaSession.USERNAME = null
            rootView.lamaSession.PASSWORD = null
            rootView.modal.title = "No internet connexion"
            rootView.modal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application."
            rootView.modal.setLoadingState(false)
            rootView.modal.enableButton = true
        }
        else
        {
            rootView.lamaSession.IS_LOGGED = true
            rootView.lamaSession.TOKEN = userInfos.token
            rootView.lamaSession.IS_LOGGED = true
            loadItineraries()
            getFurtherUserDetails()
        }
    })
}

function getFurtherUserDetails()
{
    //EMAIL = userInfos.email
    //AVATAR = userInfos.avatar
    //saveSessionState()
}

function loadItineraries()
{
    itineraryServices.getItineraries(null, rootView.lamaSession.USERNAME, "true", "",
                                     function (success, userRoutes)
    {
        if (success !== 0 || userRoutes === null
            || typeof(userRoutes) !== "object" || !(userRoutes instanceof Array))
        {
            rootView.modal.title = "No stable internet connexion"
            rootView.modal.message = "Please check your connectivity to the internet.\n"
                                + "once it's done you shall restart the application.\n\n"
                                + "We've been able to connect you but not gather your settings."
            rootView.modal.setLoadingState(false)
            rootView.modal.enableButton = true
        }
        else
        {

            rootView.lamaSession.KNOWN_ITINERARIES = userRoutes
            rootView.modal.message = "You've successfully logged in !"
            rootView.modal.setLoadingState(false)
            rootView.modal.enableButton = true
            saveSessionState()
        }
    })

}
