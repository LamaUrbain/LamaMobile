import QtQuick 2.5

QtObject {
    property bool logged: false
    property string username: ""
    property string password: ""
    property string email: ""

    function clear()
    {
        logged = false;
        username = "";
        password = "";
        email = "";
    }
}
