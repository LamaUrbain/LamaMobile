var LAMA_API_BASE_ADDR = "http://api.lamaurbain.cha.moe"
var xhr = null;
var requestHandler = null;

function requestAPI(method, route, jsonParams, callBack, token)
{// TODO call user services to dispatch network on native side
    if (xhr != null)
        return (false);

    requestHandler = callBack;
    xhr = new XMLHttpRequest();

    xhr.onreadystatechange = onStateChange;
    xhr.open(method, LAMA_API_BASE_ADDR + route);

    if (jsonParams !== null)
    {
        xhr.setRequestHeader("Content-Type", "application/json")
        if (token !== null)
        {
            jsonParams["token"] = token
        }

        xhr.body = JSON.stringify(jsonParams);
        xhr.setRequestHeader("Content-Length", xhr.body.length)
        console.log(xhr.body.length)
        console.log(xhr.body)
    }

    xhr.send();
    return (true);
}

function onStateChange()
{
    if (xhr.readyState === XMLHttpRequest.DONE)
    {
        var isSuccess = (xhr.status >= 200 || xhr.status < 300) // Assuming there is no progressive API calls
        var object = null
        try
        {
            object = JSON.parse(xhr.responseText.toString());
        }
        catch (e)
        {
            object = null
        }
        console.log("------HTTP Response------");
        console.log(xhr.status);
        console.log(xhr.statusText);
        if (isSuccess === false && object !== null)
            console.log(object["message"]);
        else
            console.log("[No object]");
        console.log("-------------------------");
        requestHandler((object != null && isSuccess), object)
        xhr = null;
        requestHandler = null;
    }
}

