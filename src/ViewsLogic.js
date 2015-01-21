var favoriteAddressList = ["777 impasse de la chance"]

var recentAdressList =
        ["1337 avenue de l'élite", "420 boulevard de la weed", "360 rue du QuickScope"]

function fillRecentLocations(listModel, needle)
{
    listModel.clear();

    for (var idx = 0; idx < recentAdressList.length; ++idx)
        if (recentAdressList[idx].toLowerCase().indexOf(needle.toLowerCase()) > -1)
            listModel.append(
                {
                    "address": recentAdressList[idx],
                });
}

function fillFavoriteLocations(listModel)
{
    for (var idx = 0; idx < favoriteAddressList.length; ++idx)
        listModel.append(
            {
                "address": favoriteAddressList[idx],
            });
}
