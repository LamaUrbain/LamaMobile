import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Rectangle {

    Components.Marker {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

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
                id: emailForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                fieldName: "Email"
            }

            Components.FormEntry {
                id: passwordForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: emailForm.bottom
                isPassword: true
                fieldName: "Password"

            }

            Components.Marker {
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
                    centerText: "Forgot your password ?"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * 0.5
                    height: parent.height
                    onClicked: {
                        mainView.mainViewTo("UserForgottenPassword")
                    }
                }
                Components.Marker {
                    id: subscribeButton
                    centerText: "Subscribe now !"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.width * 0.5
                    anchors.bottom: parent.bottom
                    onClicked: {
                       mainView.mainViewTo("UserRegistration")
                    }
                }
            }
        }


        Components.BottomAction {
            Controls.NavigationButton {
                anchors.fill: parent
                centerText: "Connect"
                navigationTarget: "Map"
            }
        }
    }
}
