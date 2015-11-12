.import QtQml 2.2 as Qml
.import "qrc:/APILogic.js" as Api
.import "qrc:/UserSession.js" as UserSession

var MinLength = 2;

function checkInput(nickname)
{
    return (nickname.length < MinLength)
}

function checkMail(mail)
{
   var at_Index = mail.indexOf('@')
   return (at_Index <= 0 || mail.lastIndexOf('.') < at_Index || mail.length < 6)
}

function checkPassword(pass, passConfirm)
{
    return (pass.length < MinLength * 2 || pass !== passConfirm);
}

function reportEvent(name, begin, end, address)
{
    var callback = function(name, begin, end, address)
    {
        return function (obj)
        {
            if (obj)
            {
                console.log(obj.latitude, obj.longitude)
                var position = JSON.toString({
                    longitude: obj.longitude,
                    latitude: obj.latitude
                })
                UserSession.reportEvent(name, begin, end, position, address)
            }
            else
                console.log("geocoging failed.")
        }
    };

    Api.prepare(address, callback(name, begin, end, address))
}
