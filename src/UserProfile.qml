import QtQuick 2.5
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    color: Constants.LAMA_BACKGROUND2

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: "Your profile"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 35
            Layout.fillWidth: true
            Layout.fillHeight: true

            Controls.ImageGravatar {
                email: rootView.session.email
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                spacing: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Components.TextLabel {
                    text: "Username"
                }

                Components.TextField {
                    text: rootView.session.username
                    readOnly: true
                    height: 55
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }

                Components.TextLabel {
                    text: "Email"
                }

                Components.TextField {
                    text: rootView.session.email
                    readOnly: true
                    height: 55
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 15
            anchors {
                left: parent.left
                right: parent.right
            }

            Controls.NavigationButton {
                text: "Your favorites"
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_FAVORITE_RESSOURCE
                navigationTarget: "FavoriteItineraries"
            }

            RowLayout {
                height: logoutButton.height
                spacing: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Controls.NavigationButton {
                    text: "Your settings"
                    primary: false
                    Layout.fillWidth: true
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    source: Constants.LAMA_SETTINGS_RESSOURCE
                    navigationTarget: "UserAccount"
                }

                Controls.NavigationButton {
                    id: logoutButton
                    text: "Logout"
                    primary: false
                    Layout.fillWidth: true
                    source: Constants.LAMA_LOGOUT_RESSOURCE
                    acceptClick: false
                    onClicked: {
                        rootView.logout();
                        rootView.mainViewTo("Map", false, null);
                    }
                }
            }
        }
    }
}
