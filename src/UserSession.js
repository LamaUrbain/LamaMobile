.import QtQuick.LocalStorage 2.0 as Sql

var LAMA_LOCALDB_NAME = "LamaLocalDB"
var LAMA_LOCALDB_TABLENAME = "USER"
var LAMA_LOCALDB_VERSION = "1.0"
var LAMA_LOCALDB_DESC = "The llama urbain DB"
var LAMA_LOCALDB_ESIZE = 1 * 1024 * 1024

var LAMA_USERCOLUMN_USERNAME = "user_name"
var LAMA_USERCOLUMN_PASSWORD = "user_password"
var LAMA_USERCOLUMN_EMAIL = "user_email"
var LAMA_USERCOLUMN_AVATAR = "user_avatar"
var LAMA_USERCOLUMN_KNOWN_ITINERARIES = "user_knownroutes"

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

var mainModal;

// This does not work, because sqlite refuse to configure pragmas in a transaction...
function bootstrap_pragma(tx) {
    tx.executeSql(""
                  + "PRAGMA foreign_keys = ON;");
}

function bootstrap_user(tx) {
    tx.executeSql( "CREATE TABLE IF NOT EXISTS USER ("
                      + "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                      + LAMA_USERCOLUMN_USERNAME + " TEXT,"
                      + LAMA_USERCOLUMN_PASSWORD + " TEXT,"
                      + LAMA_USERCOLUMN_EMAIL + " TEXT,"
                      + LAMA_USERCOLUMN_AVATAR + " TEXT,"
                      + LAMA_USERCOLUMN_KNOWN_ITINERARIES + " TEXT"
                  + ");")
}

function bootstrap_history(tx) {
    tx.executeSql(""
                  + "CREATE TABLE IF NOT EXISTS HISTORY ("
                      + "history_datetime TEXT,"
                      + "place_title TEXT,"
                      + "place_icon BLOB,"
                      + "place_name TEXT,"
                      + "place_latitude REAL,"
                      + "place_longitude REAL,"
                      + "PRIMARY KEY (place_longitude, place_latitude)"
                  + ");")
}


function createDBCallback(db)
{
    if (db.version === '')
        db.changeVersion("", LAMA_LOCALDB_VERSION);

    db.transaction(function (tx)
    {
        console.log("bootstraping db")
        var tables = [
                    bootstrap_pragma,
                    bootstrap_user,
                    bootstrap_history
                ]
        for (var i = 0; i < tables.length; ++i)
        {
            console.log("[%1/%2]".arg(i + 1).arg(tables.length), tables[i].name)
            tables[i](tx)
        }
        console.log("database bootstraped")
    });
    return (db);
}

/*
    This file HAS to be stateless, dont ask questions, having a DB descriptor is useless since it's not saved

    If you wanna know why is has to be stateless, test the application before commiting/pushing to see if
    your modifications haven't broken what's already settled up [...]
 */
function openDb()
{
    return (Sql.LocalStorage.openDatabaseSync(LAMA_LOCALDB_NAME,
                                      "",//LAMA_LOCALDB_VERSION,
                                      LAMA_LOCALDB_DESC,
                                      LAMA_LOCALDB_ESIZE,
                                      createDBCallback));
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
                if (row[LAMA_USERCOLUMN_USERNAME].length > 0)
                    rootView.lamaSession.USERNAME = row.user_name.replace(/'/g, '"')
                if (row[LAMA_USERCOLUMN_PASSWORD].length > 0)
                    rootView.lamaSession.PASSWORD = row.user_password.replace(/'/g, '"')
                if (row[LAMA_USERCOLUMN_EMAIL].length > 0)
                    rootView.lamaSession.KNOWN_ITINERARIES = JSON.parse(row.user_knownroutes.replace(/'/g, '"'))
                if (row[LAMA_USERCOLUMN_AVATAR].length > 0)
                    rootView.lamaSession.EMAIL = row.user_email.replace(/'/g, '"')
                if (row[LAMA_USERCOLUMN_KNOWN_ITINERARIES].length > 0)
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
                name: LAMA_USERCOLUMN_USERNAME,
                value: rootView.lamaSession.USERNAME
            },
            {
                name: LAMA_USERCOLUMN_PASSWORD,
                value: rootView.lamaSession.PASSWORD
            },
            {
                name: LAMA_USERCOLUMN_EMAIL,
                value: rootView.lamaSession.EMAIL
            },
            {
                name: LAMA_USERCOLUMN_AVATAR,
                value: rootView.lamaSession.AVATAR
            },
            {
                name: LAMA_USERCOLUMN_KNOWN_ITINERARIES,
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

function fillHistory(model, limit)
{
    var db = openDb()

    db.readTransaction(function (tx) {
        var tr =  "SELECT * from HISTORY ORDER BY HISTORY.history_datetime LIMIT ?;"
        var rq = tx.executeSql(tr, [limit]);

        model.clear()
        for (var i = 0; i < rq.rows.length; ++i)
        {
            var row = rq.rows.item(i)
            console.debug("[%1/%2] history: ".arg(i + 1).arg(rq.rows.length), row.place_name)
            model.append({'place': row})
        }
    })

}

function fillHistoryFiltered(model, pattern, limit)
{
    var db = openDb()

    db.readTransaction(function (tx) {
        var tr = "SELECT * from HISTORY WHERE HISTORY.place_name LIKE ? ORDER BY HISTORY.history_datetime LIMIT ?;"
        var rq = tx.executeSql(tr, ["%%1%".arg(pattern), limit]);

        model.clear()
        for (var i = 0; i < rq.rows.length; ++i)
        {
            var row = rq.rows.item(i)
            model.append({'place': row})
        }
    })
}


function addToHistory(place)
{
    var db = openDb()

    db.transaction(function (tx){
        var tr = "INSERT OR REPLACE INTO HISTORY (history_datetime, place_title, place_icon, place_name, place_latitude, place_longitude) VALUES (datetime('now'), ?, ?, ?, ?, ?);";
        var res = tx.executeSql(tr, [
                                    place["place_title"],
                                    place["place_icon"],
                                    place["place_name"],
                                    place["place_latitude"],
                                    place["place_longitude"]]);
    })
}
