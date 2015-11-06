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
            title: "Sign up"
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
                id: nameForm
                anchors.left: parent.left
                anchors.right: parent.right
                fieldName: "Name"
            }

            Components.FormEntry {
                id: emailForm
                anchors.left: parent.left
                anchors.right: parent.right
                fieldName: "Email"
            }

            Components.FormEntry {
                id: passwordForm
                anchors.left: parent.left
                anchors.right: parent.right
                fieldName: "Password"
                isPassword: true
            }

            Components.FormEntry {
                id: passwordConfirmForm
                anchors.left: parent.left
                anchors.right: parent.right
                labelText: "Confirm"
                textFieldPlaceHolder: "Confirm Password"
                isPassword: true
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
                source: Constants.LAMA_SIGNUP_RESSOURCE
                text: "Sign up"
                navigationTarget: "Map"
                acceptClick: false
                onNavButtonPressed:
                {
                    var mail = emailForm.textFieldText;
                    var nickname = nameForm.textFieldText;
                    var pass = passwordForm.textFieldText;
                    if (ViewsLogic.checkInput(nickname) === false &&
                            ViewsLogic.checkMail(mail) === false &&
                            ViewsLogic.checkPassword(pass, passwordConfirmForm.textFieldText) === false)
                    {
                        rootView.register(nickname, pass, mail);
                    }
                    else
                    {
                        mainModal.title = "Sign up error";
                        mainModal.message = "Username needs to be at least " + Constants.LAMA_MIN_INPUT_LENGTH + " characters long\n"
                                + "Email has to be valid\n"
                                + "Password needs to be at least " + Constants.LAMA_MIN_INPUT_LENGTH * 2 + " characters long\n"
                                + "Both passwords must match.";
                        mainModal.loading = false;
                        mainModal.visible = true;
                    }
                }
            }

            Controls.NavigationButton {
                text: "Login"
                primary: false
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_SIGNIN_RESSOURCE
                navigationTarget: "UserAuth"
                replace: true
            }
        }
    }
}
