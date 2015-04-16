import QtQuick 2.0
import MapControls 1.0
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "ViewsData.js" as ViewsData

Rectangle {
    property alias mapComponent: mapWidget
    anchors.fill:  parent

    color: "#0F0"

    PinchArea
    {
        anchors.fill: parent
        MapWidget
        {
            id: mapWidget
            anchors.fill: parent

            MapGetter
            {
                id: mapGetter
                Component.onCompleted:
                {
                    mapGetter.setWidget(mapWidget);
                }
            }
        }

        pinch.maximumScale: 2
        pinch.minimumScale: -2
        onPinchFinished:
        {
            var currentScale = Math.round(pinch.scale)
            if (currentScale != 0)
            {
                var zoomLevel = mapWidget.getMapScale()
                zoomLevel += 1 - (currentScale < 0) * 2
                mapWidget.setMapScale(zoomLevel)
            }
        }
    }

    Components.CommandBar
    {
        id: commandBar
        Controls.MenuButton
        {
            onMenuButtonPressed:
            {
                mainView.navigateToMenu()
            }

            width: parent.width * 0.1;
            anchors.leftMargin: width;
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        Controls.SearchButton
        {
            onSearchButtonPressed:
            {
                mainView.navigateToSearch()
            }

            width: parent.width * 0.1;
            anchors.rightMargin: width;
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}

