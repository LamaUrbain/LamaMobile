import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/APILogic.js" as APILogic

Components.Background {

    Components.Header {
        id: header
        title: "Forgotten Password"
    }

    Components.Marker {
        id: userPwd
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.8
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Components.FormEntry {
            id: usernameForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            fieldName: "Username"
            textFieldText: rootView.lamaSession.USERNAME
        }
        Components.FormEntry {
            id: emailForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: usernameForm.bottom
            fieldName: "Email"
            textFieldText: rootView.lamaSession.EMAIL
        }

    }

    Components.BottomAction {
        Controls.NavigationButton {
            id: navButton
            anchors.fill: parent
            centerText: "Ask for a new password"
            navigationTarget: "UserAuth"
            onNavButtonPressed:
            {
                var nickname = usernameForm.textFieldText
                var mail = emailForm.textFieldText
                if (ViewsLogic.checkInput(nickname) === false
                    && ViewsLogic.checkMail(mail) === false)
                {
                    mainModal.title = "Password request"
                    mainModal.setLoadingState(true);
                    mainModal.enableButton = false
                    mainModal.visible = true;

                    if (APILogic.requestAPI("GET", "/users/" + nickname + "/", null, onGetUserResult, null) === false)
                    {
                        mainModal.message = "Check your internet connection";
                        mainModal.setLoadingState(false);
                        mainModal.enableButton = true
                    }
                }
                else
                {
                    mainModal.title = "Invalid informations"
                    mainModal.message = "Please make sure your informations are correct"
                    mainModal.visible = true;
                }

                this.acceptClick = false
            }

            function onGetUserResult(status, json)
            {
                if (status === false)
                {
                    mainModal.message = "Sorry, it seems your informations are incorrect."
                    mainModal.setLoadingState(false);
                    mainModal.enableButton = true;
                    navButton.acceptClick = true
                }
                else
                {
                    rootView.lamaSession.PASSWORD = ViewsLogic.getRandomString(Constants.LAMA_PASSWORD_RANDOM_LENGTH)
                    var params = {
                        password: rootView.lamaSession.PASSWORD,
                        username: usernameForm.textFieldText
                    }

                    APILogic.requestAPI("PATCH", "/users/" + json["username"] + "/", params, onEditUserResult, null)
                }
            }

            function onEditUserResult()
            {
                if (status === true)
                {
                    mainModal.message = "Your password has been reset to :\n" + rootView.lamaSession.PASSWORD
                    mainModal.onModalButtonClicked.connect(newPasswordSet_ClickedModal)
                }
                else
                {
                    rootView.lamaSession.PASSWORD = ""
                    mainModal.message = "Sorry, we could not reset your password."
                }
                mainModal.setLoadingState(false);
                mainModal.enableButton = true;
                navButton.acceptClick = true
            }

            function newPasswordSet_ClickedModal()
            {
                mainModal.modalButtonClicked.disconnect(newPasswordSet_ClickedModal);
                navButton.navigate()
            }
        }
    }
}
