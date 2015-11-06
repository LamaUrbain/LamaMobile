import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import QtPositioning 5.3
import QtLocation 5.3

import "qrc:/Views" as Views
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/UILogic.js" as UiLogic
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession

Window {
    id: rootView
    visible: true
    width: 576
    height: 960

    property alias currentItinerary: currentItinerary
    property alias session: session
    property alias sponsors: sponsors
    property alias modal: mainModal
    property alias mainView: mainView
    property alias menuView: menuView
    property alias mapView: mapView

    Components.Itinerary { id: currentItinerary }
    Components.Session { id: session }
    ListModel { id: sponsors }

    Views.Map {
        id: mapView
        anchors.fill: parent
    }

    StackView {
        id: mainView
        anchors.fill: parent
        initialItem: "qrc:/Views/Home.qml"
    }

    Components.MaskBackground {
        enabled: menuView.displayed
        anchors.fill: parent
        onCancelRequest: {
            menuView.displayed = false;
        }
    }

    Views.Menu {
        id: menuView
        width: 350
        x: displayed ? 0 : -width
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        Behavior on x { NumberAnimation { duration: 150 } }
    }

    Views.Modal {
        id: mainModal
        anchors.fill: parent
    }

    Plugin {
        id: geoPlugin
        name: "osm"
        PluginParameter { name: "osm.useragent"; value: Constants.LAMA_OSM_USERAGENT }
        Component.onCompleted: {
            var features =  [
                [Plugin.OnlinePlacesFeature, 'Online places is supported.'],
                [Plugin.OfflinePlacesFeature, 'Offline places is supported.'],
                [Plugin.SavePlaceFeature, 'Saving categories is supported.'],
                [Plugin.RemovePlaceFeature, 'Removing or deleting places is supported.'],
                [Plugin.PlaceRecommendationsFeature, 'Searching for recommended places similar to another place is supported.'],
                [Plugin.SearchSuggestionsFeature, 'Search suggestions is supported.'],
                [Plugin.LocalizedPlacesFeature, 'Supports returning localized place data.'],
                [Plugin.NotificationsFeature, 'Notifications of place and category changes is supported.'],
                [Plugin.PlaceMatchingFeature, 'Supports matching places from two different geo service providers.'],
                [Plugin.AnyPlacesFeatures, 'Matches a geo service provider that provides any places features.']
            ];
            for (var i = 0; i < features.length; ++i)
            {
                var feat = features[i][0];
                var diag = features[i][1];
                if (geoPlugin.supportsPlaces(feat))
                    console.log("%1:".arg(geoPlugin.name), diag);
            }
        }
    }

    function mainViewTo(name, replace, prop)
    {
        if (mainView.busy)
            return;

        if (name === undefined || name === "Map")
            mainView.pop(null);
        else if (replace)
            mainView.push({ item: "qrc:/Views/" + name + ".qml", replace: replace, properties: prop });
        else
            mainView.push({ item: "qrc:/Views/" + name + ".qml", properties: prop });
    }

    function mainViewBack()
    {
        if (mainView.busy)
            return;

        if (mainView.currentItem != mapView)
            mainView.pop();
    }

    function clearItinerary() { UiLogic.clearItinerary(); }
    function homeSearch(departure) { UiLogic.homeSearch(departure); }
    function mainSearch(itinerary) { UiLogic.mainSearch(itinerary); }
    function displayItinerary(id) { UiLogic.displayItinerary(id); }
    function deleteItinerary(id, then) { UiLogic.deleteItinerary(id, then); }
    function getMapAddress(coords, then) { UiLogic.getMapAddress(coords, then); }
    function setMapDeparture(address) { UiLogic.setMapDeparture(address); }
    function addMapDestination(address) { UiLogic.addMapDestination(address); }
    function setMapDestination(address) { UiLogic.setMapDestination(address); }
    function moveMapDestination(position, coords) { UiLogic.moveMapDestination(position, coords); }
    function register(username, password, email) { UserSession.register(username, password, email); }
    function authenticate(username, password) { UserSession.authenticate(username, password); }
    function logout() { UserSession.logout(); }
    function editAccount(password, email) { UserSession.editAccount(password, email); }
    function loadFavorites(username, then) { UserSession.loadFavorites(username, then); }

    Component.onCompleted: {
        // Avoid blocking the UI thread
        initializeTimer.start();
    }

    Timer {
        id: initializeTimer
        interval: 1
        running: false
        repeat: false
        onTriggered: UserSession.initialize();
    }
}
