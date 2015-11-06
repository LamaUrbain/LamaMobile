import QtQuick 2.5
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
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
            title: "Login"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            Components.FormEntry {
                id: usernameForm
                fieldName: "Username"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormEntry {
                id: passwordForm
                isPassword: true
                fieldName: "Password"
                anchors {
                    left: parent.left
                    right: parent.right
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
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_SIGNIN_RESSOURCE
                text: "Login"
                acceptClick: false
                onNavButtonPressed:
                {
                    var nick = usernameForm.textFieldText;
                    var pass = passwordForm.textFieldText;
                    if (ViewsLogic.checkInput(nick) === false && ViewsLogic.checkInput(pass) === false)
                        rootView.authenticate(nick, pass);
                    else
                    {
                        rootView.modal.loading = false;
                        rootView.modal.title = "Authentification error"
                        rootView.modal.message = "It seems you have mistyped your login and/or your password."
                        rootView.modal.visible = true;
                    }
                }
            }

            Controls.NavigationButton {
                text: "Sign up"
                primary: false
                source: Constants.LAMA_SIGNUP_RESSOURCE
                anchors.left: parent.left
                anchors.right: parent.right
                navigationTarget: "UserRegistration"
                replace: true
            }
        }
    }
}
