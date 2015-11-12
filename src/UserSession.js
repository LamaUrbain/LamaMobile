.import QtQuick.LocalStorage 2.0 as Sql
.import "APILogic.js" as Api

var LAMA_LOCALDB_NAME = "LamaLocalDB"
var LAMA_LOCALDB_TABLENAME = "USER"
var LAMA_LOCALDB_VERSION = "1.0"
var LAMA_LOCALDB_DESC = "The llama urbain DB"
var LAMA_LOCALDB_ESIZE = 1 * 1024 * 1024
var LAMA_USERCOLUMN_USERNAME = "user_name"
var LAMA_USERCOLUMN_PASSWORD = "user_password"

var database = null;

function startRequest()
{
    mainModal.loading = true;
    mainModal.visible = true;
}

function endRequest(then, hide)
{
    return function(success, obj)
    {
        if (!success)
        {
            rootView.modal.loading = false;
            rootView.modal.title = "Error";
            rootView.modal.message = obj;
            rootView.modal.visible = true;
        }
        else
        {
            if (hide)
                mainModal.visible = false;
            if (then)
                then(obj);
        }
    }
}

function saveSession()
{
    database.transaction(function(tx)
    {
        var result = tx.executeSql(
                    "INSERT OR REPLACE INTO " + LAMA_LOCALDB_TABLENAME + " ("
                    + "id, "
                    + LAMA_USERCOLUMN_USERNAME + ", "
                    + LAMA_USERCOLUMN_PASSWORD + ")"
                    + "VALUES ("
                    + "1, "
                    + "\"" + rootView.session.username.replace(/"/g, "'") + "\", "
                    + "\"" + rootView.session.password.replace(/"/g, "'") + "\""
                    + ");");

        if (result && result.rowsAffected > 0)
            console.log("Offline data saved !");
        else
            console.log("Could not save offline data !");
    });
}

function clearSession()
{
    rootView.session.clear();
    database.transaction(function(tx)
    {
        tx.executeSql("DELETE FROM " + LAMA_LOCALDB_TABLENAME);
    });
}

function initialize()
{
    rootView.session.clear();

    function createDBCallback(db)
    {
        if (db.version === '')
            db.changeVersion("", LAMA_LOCALDB_VERSION);

        db.transaction(function(tx)
        {
            console.log("bootstraping db");

            tx.executeSql("CREATE TABLE IF NOT EXISTS " + LAMA_LOCALDB_TABLENAME  + " ("
                          + "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                          + LAMA_USERCOLUMN_USERNAME + " TEXT,"
                          + LAMA_USERCOLUMN_PASSWORD + " TEXT"
                          + ");");

            console.log("database bootstraped");
        });
        return (db);
    }

    database = Sql.LocalStorage.openDatabaseSync(
                LAMA_LOCALDB_NAME,
                "",
                LAMA_LOCALDB_DESC,
                LAMA_LOCALDB_ESIZE,
                createDBCallback);

    database.transaction(function(tx)
    {
        var query = tx.executeSql("SELECT * FROM " + LAMA_LOCALDB_TABLENAME + ";");
        if (query.rows.length > 0)
        {
            var row = query.rows.item(0);
            if (row[LAMA_USERCOLUMN_USERNAME].length > 0)
                rootView.session.username = row.user_name.replace(/'/g, '"');
            if (row[LAMA_USERCOLUMN_PASSWORD].length > 0)
                rootView.session.password = row.user_password.replace(/'/g, '"');
            console.log("Offline data loaded !")
        }
        else
            console.log("Unable to load offline data...")
    });

    loadSponsors();
    loadEvents();

    if (rootView.session.username && rootView.session.password)
        authenticate(rootView.session.username, rootView.session.password);
}

function register(username, password, email)
{
    var callback = function()
    {
        return function(obj)
        {
            rootView.mainViewBack();
        }
    };

    startRequest();
    Api.createUser(username, password, email, endRequest(callback(), true));
}

function authenticate(username, password)
{
    if (!username || !password)
        return;

    startRequest();

    // Two steps:
    // 1) Authenticate the user
    // 2) Get the user's information to fill the session
    // 3) Save the user's information

    var callback = function(username, password)
    {
        return function(obj)
        {
            var getUserCallback = function(username, password, token)
            {
                return function(obj)
                {
                    clearSession();

                    if (obj && "email" in obj && obj.email)
                        rootView.session.email = obj.email;

                    // 3) Save the user's information
                    rootView.session.logged = true;
                    rootView.session.username = username;
                    rootView.session.password = password;
                    saveSession();

                    rootView.mainViewBack();
                }
            };

            // 2) Get the user's information to fill the session
            Api.getUser(username, endRequest(getUserCallback(username, password, obj.token), true));
        }
    };

    // 1) Authenticate the user
    Api.authenticate(username, password, endRequest(callback(username, password), false));
}

function logout()
{
    if (!rootView.session.logged)
        return;

    var callback = function()
    {
        return function(obj)
        {
            clearSession();
        }
    };

    startRequest();
    Api.logout(endRequest(callback(), true));
}

function editAccount(password, email)
{
    if (!rootView.session.logged || !rootView.session.username)
        return;

    var callback = function()
    {
        return function(obj)
        {
            rootView.mainViewBack();
        }
    };

    startRequest();
    Api.editUser(rootView.session.username, password, email, null, endRequest(callback(), true));
}

function loadFavorites(username, then)
{
    startRequest();

    var callback = function(then)
    {
        return function(obj)
        {
            var favorites = new Array;

            if (obj && obj.length > 0)
                for (var i = 0; i < obj.length; ++i)
                {
                    var itinerary = obj[i];
                    var data = {
                        id: itinerary.id,
                        name: itinerary.name ? itinerary.name : "Your itinerary"
                    };
                    favorites.push(data);
                }

            then(favorites);
        }
    };

    Api.getItineraries(username, "true", endRequest(callback(then), true));
}

function loadSponsors()
{
    var callback = function(obj)
    {
        sponsors.clear();

        if (obj && obj.length > 0)
            for (var i = 0; i < obj.length; ++i)
            {
                var sponsor = obj[i];
                sponsors.append({ username: sponsor.username, email: sponsor.email });
            }
    };

    Api.getUsers("", "true", endRequest(callback, false));
}

function loadEvents()
{
    var callback = function(status, obj)
    {
        events.clear();

        console.log("load", obj.length, "events into model", events)
        if (obj && obj.length > 0)
        {
            for (var i = 0; i < obj.length; ++i)
            {
                var event = obj[i];
                events.append({name: event.name, begin: event.begin, end: events.end, position: event.position})
            }
        }
        events.eventChanged();
    }
    Api.getEvents(callback)
}
