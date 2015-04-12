.pragma library
.import "ViewsData.js" as ViewsData

function fillRecentLocations(listModel, needle)
{
    listModel.clear();
    if (listModel.count === 0 || needle.length > 0)
        for (var idx = 0; idx < ViewsData.recentAddressList.length; ++idx)
            if (ViewsData.recentAddressList[idx].toLowerCase().indexOf(needle.toLowerCase()) > -1)
                listModel.append(
                    {
                        "address": ViewsData.recentAddressList[idx],
                    });
}


function fillSuggestions(listModel, needle)
{
    listModel.clear();

    if (needle.length > 0)
        for (var idx = 0; idx < ViewsData.knownAddresses.length; ++idx)
            if (ViewsData.knownAddresses[idx].toLowerCase().indexOf(needle.toLowerCase()) > -1)
                listModel.append(
                    {
                        "address": ViewsData.knownAddresses[idx],
                    });
}

function fillFavoriteLocations(listModel)
{
    for (var idx = 0; idx < ViewsData.favoriteAddressList.length; ++idx)
        listModel.append(
            {
                "address": ViewsData.favoriteAddressList[idx],
            });
}

var suggestionsOverLayView;
var originTextControl;
function displaySuggestionsView(viewContainer, textInputControl, needle)
{
    originTextControl = textInputControl;
    suggestionsOverLayView = Qt.createComponent("qrc:/Views/Suggestions.qml").createObject(viewContainer, {});
}

function leaveDisplay(selection)
{
    if (selection !== null)
        originTextControl.text = selection
    suggestionsOverLayView.destroy();
}

