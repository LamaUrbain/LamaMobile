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
            title: "User Account Management"
        }

        Components.Marker {
            id: informations
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.Marker {
                id: username
                centerText: "Username"
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.75
                height: parent.height
            }

            Components.Marker {
                id: avatar
                centerText: "Avatar"
                anchors.left: username.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }

        Components.Marker {
            id: options
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: informations.bottom
            height: parent.height * 0.7
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.Marker {
                id: changePassword
                centerText: "Change Password:"
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.height * 0.75
                height: parent.height * 0.1
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: ancientPwdLabel
                centerText: "Current Password"
                anchors.left: parent.left
                anchors.top: changePassword.bottom
                anchors.right: parent.right
                height: parent.height * 0.1
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: newPwdLabel
                centerText: "New Password"
                anchors.left: parent.left
                anchors.top: ancientPwdLabel.bottom
                anchors.right: parent.right
                height: parent.height * 0.1
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

            Components.Marker {
                id: confirmPwdLabel
                centerText: "Confirm New Password"
                anchors.left: parent.left
                anchors.top: newPwdLabel.bottom
                anchors.right: parent.right
                height: parent.height * 0.1
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005
            }

        }

        Components.BottomAction {
            id: saveButton
            centerText: "Save settings"
        }
    }
}
