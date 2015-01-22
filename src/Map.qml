import QtQuick 2.0
import MapControls 1.0
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls

Rectangle {
    anchors.fill:  parent;

    color: "#0F0"

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

    /*
        Include map Here once Git has been correctly re-arranged
    */

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

