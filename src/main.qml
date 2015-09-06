import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3

import QtPositioning 5.3

import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls

import "qrc:/Constants.js" as Constants
import "qrc:/MapLogic.js" as MapLogic
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

import QtLocation 5.3

Window {
    id: rootView
    visible: true
    width: 640
    height: 960

    signal userSessionChanged()
    signal triggerLogin(bool clearData)
    onTriggerLogin:
    {
        tryLogin(clearData)
    }

    property var lamaSession: UserSession.LAMA_SESSION
    property alias modal: mainModal
    property alias mainView: mainView
    property QtObject mapView: null

    StackView {
        id: mainView
        anchors.fill: parent
        initialItem: "qrc:/Views/Map.qml"
    }

    Views.Modal
    {
        id: mainModal
        Component.onCompleted:
        {
            //testing
        }
    }

    // Plugin for geocoding.
    Plugin {
        id: geoPlugin
        name: "osm"
        PluginParameter { name: "osm.useragent"; value: Constants.LAMA_OSM_USERAGENT }
        Component.onCompleted: {
            var features =  [
                [Plugin.OnlinePlacesFeature, 'Online places is supported.'],
                [Plugin.OfflinePlacesFeature,	'Offline places is supported.'],
                [Plugin.SavePlaceFeature,	'Saving categories is supported.'],
                [Plugin.RemovePlaceFeature,	'Removing or deleting places is supported.'],
                [Plugin.PlaceRecommendationsFeature,	'Searching for recommended places similar to another place is supported.'],
                [Plugin.SearchSuggestionsFeature,	'Search suggestions is supported.'],
                [Plugin.LocalizedPlacesFeature,	'Supports returning localized place data.'],
                [Plugin.NotificationsFeature,	'Notifications of place and category changes is supported.'],
                [Plugin.PlaceMatchingFeature,	'Supports matching places from two different geo service providers.'],
                [Plugin.AnyPlacesFeatures,	'Matches a geo service provider that provides any places features.']
            ]
            for (var i = 0; i < features.length; ++i)
            {
                var feat = features[i][0]
                var diag = features[i][1]

                if (geoPlugin.supportsPlaces(feat))
                {
                    console.log("%1:".arg(geoPlugin.name), diag);
                }
            }
        }
    }

    function mainViewTo(name, prop)
    {
        if (name === undefined || name === "Map")
        {
            // Pops all but the first item (i.e. the map)
            mainView.pop(null);
        }
        else
        {
            mainView.push("qrc:/Views/" + name + ".qml", {properties: prop})
        }
    }

    function mainViewBack()
    {
        if (mainView.currentItem != mapView)
            mainView.pop()
    }

    function raiseUserSessionChanged()
    {
        userSessionChanged()
    }

    function resolveCurrentItinerary()
    {
        MapLogic.resolveCurrentItinerary()
    }

    function moveItineraryPoint(itineraryId, point, newCoords)
    {
        MapLogic.moveItineraryPoint(itineraryId, point, newCoords);
    }

    function tryLogin(clear)
    {
        UserSession.tryLogin(rootView, clear)
    }

    function saveSessionState()
    {
        UserSession.saveSessionState()
    }

    function fillHistory(model, limit)
    {
        UserSession.fillHistory(model, limit)
    }

    function addToHistory(term)
    {
        UserSession.addToHistory(term)
    }

    function fillHistoryFiltered(model, pattern, limit)
    {
        UserSession.fillHistoryFiltered(model, pattern, limit)
    }

    Component.onCompleted:
    {
        UserSession.tryLogin(false)
    }
}
