import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    id: menu

    property bool displayed: false

    function navigate(target)
    {
        if (target)
        {
            displayed = false;
            rootView.mainViewTo(target, false, null);
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 30

        ListModel { id: authModel }
        ListModel { id: noAuthModel }
        ListModel { id: otherModel }

        Component.onCompleted: {
            authModel.append({ name: "Your profile", icon: Constants.LAMA_PROFILE_RESSOURCE, target: "UserProfile" });
            authModel.append({ name: "Your favorites", icon: Constants.LAMA_FAVORITE_RESSOURCE, target: "FavoriteItineraries" });
            authModel.append({ name: "Your settings", icon: Constants.LAMA_SETTINGS_RESSOURCE, target: "UserAccount" });
            authModel.append({ name: "Logout", icon: Constants.LAMA_LOGOUT_RESSOURCE, target: "UserLogout", isLogout: true });

            noAuthModel.append({ name: "Sign Up", icon: Constants.LAMA_SIGNUP_RESSOURCE, target: "UserRegistration" });
            noAuthModel.append({ name: "Login", icon: Constants.LAMA_SIGNIN_RESSOURCE, target: "UserAuth" });

            otherModel.append({ name: "Sponsors", icon: Constants.LAMA_SPONSORS_RESSOURCE, target: "SponsoredPaths" });
            otherModel.append({ name: "Incidents", icon: Constants.LAMA_INCIDENT_RESSOURCE, target: "Incidents" });
            otherModel.append({ name: "Contact", icon: Constants.LAMA_CONTACT_RESSOURCE, target: "UserContact", isContact: true });
        }

        Components.Header {
            id: header
            title: "Lama "
            titleSecondary: "Urbain"
            autoBack: false
            onBackClicked: displayed = false;
        }

        Column {
            id: authView
            spacing: 15
            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
                topMargin: 45
            }

            Controls.MenuCategory {
                text: rootView.session.logged ? "You" : "Welcome"
                textArea.font.pixelSize: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Repeater {
                model: rootView.session.logged ? authModel : noAuthModel
                delegate: Controls.MenuButton {
                    text: model.name
                    icon: model.icon
                    width: authView.width
                    onClicked: {
                        if (rootView.session.logged && authModel.get(index).isLogout)
                        {
                            displayed = false;
                            rootView.logout();
                            return;
                        }
                        navigate(model.target);
                    }
                }
            }
        }

        Column {
            id: otherView
            spacing: 15
            anchors {
                left: parent.left
                right: parent.right
                top: authView.bottom
                topMargin: 45
            }

            Controls.MenuCategory {
                text: "More"
                textArea.font.pixelSize: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Repeater {
                model: otherModel
                delegate: Controls.MenuButton {
                    text: model.name
                    icon: model.icon
                    width: otherView.width
                    onClicked: {
                        if (otherModel.get(index).isContact)
                        {
                            displayed = false;
                            Qt.openUrlExternally("http://eip.epitech.eu/2016/lamaurbain/#contact");
                            return;
                        }
                        navigate(model.target);
                    }
                }
            }
        }
    }
}
