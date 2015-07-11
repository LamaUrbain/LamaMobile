import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Views/APILogic.js" as APILogic

Components.Background {

    Components.Header {
        id: header
        title: "Registration"
    }

    Components.Marker {
        id: userAuth
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.8
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Components.FormEntry {
            id: nameForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            fieldName: "Name"
        }

        Components.FormEntry {
            id: emailForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: nameForm.bottom
            fieldName: "Email"
        }

        Components.FormEntry {
            id: passwordForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: emailForm.bottom
            fieldName: "Password"
            isPassword: true
        }

        Components.FormEntry {
            id: passwordConfirmForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: passwordForm.bottom
            labelText: "Confirm"
            textFieldPlaceHolder: "Confirm Password"
            isPassword: true
        }
    }

    Components.BottomAction {
        Controls.NavigationButton {
            id: navButton
            anchors.fill: parent
            centerText: "Register"
            navigationTarget: "Map"
            onNavButtonPressed:
            {
                var mail = emailForm.textFieldText
                var nickname = nameForm.textFieldText
                var pass = passwordForm.textFieldText
                if (ViewsLogic.checkInput(nickname) === false &&
                    ViewsLogic.checkMail(mail) === false &&
                    ViewsLogic.checkPassword(pass, passwordConfirmForm.textFieldText) === false)
                {
                    mainModal.title = "Registration"
                    mainModal.setLoadingState(true);
                    mainModal.enableButton = false
                    mainModal.visible = true;
                    var jsonParams = {
                        username: nickname,
                        password: pass,
                        email: mail
                    }
                    UserSession.LAMA_USER_IS_LOGGED = false
                    UserSession.LAMA_USER_TOKEN = ""
                    UserSession.LAMA_USER_PASSWORD = pass
                    if (APILogic.requestAPI("POST", "/users/", jsonParams, onRegistrationResult, null) === false)
                    {
                        mainModal.message = "Check your internet connection";
                        mainModal.setLoadingState(false);
                        mainModal.enableButton = true
                    }
                }
                else
                {
                    mainModal.title = "Invalid registration"
                    mainModal.message = "Username needs to be at least " + Constants.LAMA_MIN_INPUT_LENGTH + " characters long\n\n"
                                        + "Email has to be valid\n\n"
                                        + "Password needs to be at least " + Constants.LAMA_MIN_INPUT_LENGTH * 2 + " characters long\n\n"
                                        + "Both passwords must match"
                    mainModal.visible = true;
                }
                this.acceptClick = false
            }

            function registrationComplete_ClickedModal()
            {
                mainModal.modalButtonClicked.disconnect(registrationComplete_ClickedModal);
                navButton.navigate();
            }

            function onRegistrationResult(status, json)
            {
                if (status === true)
                {
                    mainModal.message = "You have successfully registratered to the \nLamaUrbain community !"
                            + "You may now proceed to log in\n\n"
                    mainModal.onModalButtonClicked.connect(registrationComplete_ClickedModal)
                }
                else
                {
                    mainModal.message = "Sorry, either someone else already uses these informations\n"
                    + "or our services are unavailable...\nPlease try again later"
                }
                mainModal.setLoadingState(false);
                mainModal.enableButton = true;
                navButton.acceptClick = true
            }
        }
    }
}
