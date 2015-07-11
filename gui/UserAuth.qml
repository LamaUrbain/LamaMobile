import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/UserSession.js" as UserSession
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Views/APILogic.js" as APILogic

Components.Background {

    Components.Header {
        id: header
        title: "User Auth"
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
            id: usernameForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            fieldName: "Username"
        }

        Components.FormEntry {
            id: passwordForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: usernameForm.bottom
            isPassword: true
            fieldName: "Password"

        }

        Row {
            id: authExtra
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.10
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.Marker {
                id: forgottenPasswordButton
                centerText: "Reset Password"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.5
                height: parent.height
                onClicked: {
                    rootView.mainViewTo("UserForgottenPassword")
                }
            }
            Components.Marker {
                id: subscribeButton
                centerText: "Subscribe Now"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.5
                onClicked: {
                    rootView.mainViewTo("UserRegistration")
                }
            }
        }
    }


    Components.BottomAction {
        Controls.NavigationButton {
            id: navButton
            anchors.fill: parent
            centerText: "Connect"
            navigationTarget: "Map"
            onNavButtonPressed:
            {
                var nick = usernameForm.textFieldText
                var pass = passwordForm.textFieldText
                if (ViewsLogic.checkMail(nick) === false &&
                    ViewsLogic.checkInput(pass) === false)
                {
                    mainModal.title = "Authentication"
                    mainModal.setLoadingState(true);
                    mainModal.enableButton = false
                    mainModal.visible = true;
                    var jsonParams = {
                        password: pass,
                        username: nick
                    }
                    UserSession.LAMA_USER_IS_LOGGED = false
                    UserSession.LAMA_USER_TOKEN = ""
                    UserSession.LAMA_USER_PASSWORD = pass
                    if (APILogic.requestAPI("POST", "/tokens/", jsonParams, onAuthResult, null) === false)
                    {
                        mainModal.message = "Check your internet connection";
                        mainModal.setLoadingState(false);
                        mainModal.enableButton = true
                    }
                }
                else
                {
                    mainModal.title = "Wrong login or password"
                    mainModal.message = "It seems you have mistyped your login and password."
                    mainModal.visible = true;
                }
                this.acceptClick = false
            }

            function authComplete_ClickedModal()
            {
                mainModal.modalButtonClicked.disconnect(authComplete_ClickedModal);
                navButton.navigate();
            }

            function onAuthResult(status, json)
            {
                if (status === true)
                {
                    UserSession.LAMA_USER_USERNAME = json["owner"]
                    UserSession.LAMA_USER_TOKEN = json["token"]
                    UserSession.LAMA_USER_IS_LOGGED = true
                    mainModal.message = "You've successfully logged in !"
                    mainModal.onModalButtonClicked.connect(authComplete_ClickedModal)
                }
                else
                {
                    mainModal.message = "Please make sure you typed your informations correctly."
                }
                mainModal.setLoadingState(false);
                mainModal.enableButton = true;
                navButton.acceptClick = true
            }
        }
    }
}
