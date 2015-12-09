import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import QtPositioning 5.3
import MapControls 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "qrc:/Views" as Views
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

Item {
    id: mapView

    property alias mapComponent: mapComponent
    property alias popoverDisplayed: popover.visible

    function getCurrentPosition()
    {
        if (mapCircle.visible)
            return Qt.point(mapCircle.coordinate);
        return mapComponent.mapCenter;
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true

        onUpdateTimeout: {
            console.log("Coordinate error:", positionSource.sourceError)
        }

        Component.onCompleted: {
            if (positionSource.valid)
                console.log("PositionSource is valid, coordinate will be available")
            else
                console.log("PositionSource is NOT valid, coordinate won't be available")
        }

        onPositionChanged: {
            var coord = positionSource.position.coordinate;
            mapCircle.coordinate.x = coord.longitude;
            mapCircle.coordinate.y = coord.latitude;
            mapCircle.visible = true;
        }
    }

    MapWidget {
        id: mapComponent
        anchors.fill: parent
        onMapPointMoved: {
            if (rootView.currentItinerary.id >= 0
                    && (!rootView.currentItinerary.owner
                        || rootView.currentItinerary.owner == rootView.session.username))
            {
                rootView.moveMapDestination(point, newCoords);
            }
        }
        onMapPointClicked: {
            if (rootView.currentItinerary.id >= 0
                    && (!rootView.currentItinerary.owner
                        || rootView.currentItinerary.owner == rootView.session.username))
            {
                var callback = function(coords)
                {
                    return function(obj)
                    {
                        var city = obj.city;
                        if (obj.postalCode)
                            city = obj.postalCode + (city ? ", " + city : "");

                        popover.address = obj.address;
                        popover.street = obj.street;
                        popover.city = city;
                        popover.coordinate = Qt.point(coords.x, coords.y);
                        popover.visible = true;
                    }
                };
                rootView.getMapAddress(coords, callback(coords));
            }
        }

        onMapEventSelected: {
            console.log(id, coords)

            var E = undefined;
            for (var i = 0; i < events.count; ++i)
            {
                var tmp = events.get(i);
                if (tmp.id == id)
                {
                    console.log("found event id", id)
                    E = tmp;
                    break;
                }
            }

            if (E == undefined)
            {
                console.log("could not find event id", id);
                return;
            }

            popover.address = E.name;
            popover.street = ""
            popover.city = "";
            popover.coordinate = coords

            if (E.position.address != null)
                popover.street = E.position.address;

            popover.visible = true;
        }

        Components.MapCircle {
            id: mapCircle
            visible: false
            color: Constants.LAMA_ORANGE
            borderWidth: 1
            borderColor: Constants.LAMA_BORDER_COLOR2
            radius: 8
        }

        Components.PopOver {
            id: popover
            visible: false
            focusScope: true
            onCancelRequest: visible = false;
            onSetDepartureRequest: {
                visible = false;
                rootView.setMapDeparture(popover.address);
            }
            onAddDestinationRequest: {
                visible = false;
                rootView.addMapDestination(popover.address);
            }
            onSetDestinationRequest: {
                visible = false;
                rootView.setMapDestination(popover.address);
            }
        }
    }
}
