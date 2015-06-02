import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.3
import "qrc:/Views" as Views
import "qrc:/Components" as Components

Window {
    id: mainView
    visible: true
    width: 640
    height: 960


    // à garder pour visualiser en attendant d'avoir les transitions
    TabView {
        anchors.fill: parent
        Tab {
            title: "Map"

            Views.Map {
                anchors.fill: parent
            }
        }
        Tab {
            title: "Menu"

            Views.Menu {
                anchors.fill: parent
            }
        }
        Tab {
            title: "Suggestions"

            Views.Suggestions {
                anchors.fill: parent
            }
        }
        Tab {
            title: "AlertInformation"

            Views.AlertInformation {
                anchors.fill: parent
            }
        }
        Tab {
            title: "FavoriteItineraries"

            Views.FavoriteItineraries {
                anchors.fill: parent
            }
        }
        Tab {
            title: "MainSearch"

            Views.MainSearch {
                anchors.fill: parent
            }
        }

        Tab {
            title: "TransportPreferences"

            Views.TransportPreferences {
                anchors.fill: parent
            }
        }
        Tab {
            title: "UserAccount"

            Views.UserAccount {
                anchors.fill: parent
            }
        }
        Tab {
            title: "UserAuth"

            Views.UserAuth {
                anchors.fill: parent
            }
        }
        Tab {
            title: "UserFeedback"

            Views.UserFeedback {
                anchors.fill: parent
            }
        }
    }
}

