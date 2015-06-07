import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Rectangle {
    Components.Marker {
        id: background
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 1

            Components.Marker {
                id: header
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: parent.width * 0.005
                anchors.rightMargin: parent.width * 0.005
                Layout.maximumHeight: parent.height * 0.075
                Layout.minimumHeight: parent.height * 0.075
                RowLayout {
                    anchors.fill: parent

                    Controls.NavigationButton {
                        Layout.fillWidth: true
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        centerText: "Search"
                        navigationTarget: "MainSearch"
                    }

                    Controls.NavigationButton {
                        Layout.fillWidth: true
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        centerText: "Menu"
                        navigationTarget: "Menu"
                    }

                    Controls.NavigationButton {
                        Layout.fillWidth: true
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        centerText: "User Auth"
                        navigationTarget: "UserAuth"
                    }
                }
            }

            Components.Marker {
                id: map
                centerText: "Map"
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.fillHeight: true

                anchors.leftMargin: parent.width * 0.005
                anchors.rightMargin: parent.width * 0.005
            }
        }
    }
}
