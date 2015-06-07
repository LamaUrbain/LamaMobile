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
                fieldName: "Password"
            }

            Components.FormEntry {
                id: passwordConfirmForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: passwordForm.bottom
                labelText: "Password"
                textFieldText: "Confirm your Password here."
            }
        }

        Components.BottomAction {
            Controls.NavigationButton {
                anchors.fill: parent
                centerText: "Register"
                navigationTarget: "Map"
            }
        }
    }
}
