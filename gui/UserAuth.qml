import QtQuick 2.0
import "qrc:/Components/" as Components

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

            Components.Marker {
                id: emailForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height * 0.3
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005

                Components.Marker {
                    id: emailLabel
                    centerText: "Email:"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.width * 0.3
                    height: parent.height * 0.5
                }
                Components.Marker {
                    id: emailField
                    centerText: "Enter your adress here."
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: emailLabel.bottom
                    height: parent.height * 0.5
                }
            }

            Components.Marker {
                id: passwordForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: emailForm.bottom
                height: parent.height * 0.3
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005

                Components.Marker {
                    id: passwordLabel
                    centerText: "Password:"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.width * 0.3
                    height: parent.height * 0.5
                }
                Components.Marker {
                    id: passwordField
                    centerText: "Enter your password here."
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: passwordLabel.bottom
                    height: parent.height * 0.5
                }
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
                }
                Components.Marker {
                    id: subscribeButton
                    centerText: "Subscribe now !"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.width * 0.5
                    anchors.bottom: parent.bottom
                }
            }
        }

        Components.BottomAction {
            id: connectButton
            centerText: "Connect"
        }
    }
}
