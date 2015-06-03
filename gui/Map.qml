import QtQuick 2.0
import QtQuick.Window 2.1
import "qrc:/Components/" as Components

Rectangle {
    Components.Marker {
        id: background
        anchors.fill: parent

        Components.Marker {
            id: map
            centerText: "Map"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: footer.top
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
        }

        Components.Marker {
            id: footer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005

            Components.Marker {
                id: searchButton
                centerText: "Search"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.75
                height: parent.height
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("MainSearch")
                }
            }

            Components.Marker {
                id: menuButton
                centerText: "Menu"
                anchors.right: parent.right
                anchors.top: parent.top
                width: parent.width * 0.25
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                onClicked: {
                    mainView.changeViewTo("Menu")
                }
            }
        }
    }
}
