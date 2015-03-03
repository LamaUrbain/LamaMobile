import QtQuick 2.2
import QtQuick.Window 2.1
import Tests 1.0

Window {
    visible: true
    width: 800
    height: 700

    MapWidget {
        id: mapWidget
        anchors.fill: parent
        mapScale: 15

        MapGetter {
            id: mapGetter

            Component.onCompleted: {
                mapGetter.setWidget(mapWidget);
            }
        }

        ItineraryStub {
            id: itineraryStub

            Component.onCompleted: {
                itineraryStub.initMapWidget(mapWidget);
            }
        }
    }
}
