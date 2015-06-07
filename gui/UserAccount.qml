import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
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

            Column {
                anchors.top: changePassword.bottom
                height: parent.height * 0.9
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: parent.height * 0.005
                anchors.rightMargin: parent.height * 0.005
                anchors.topMargin: parent.height * 0.005
                anchors.bottomMargin: parent.height * 0.005

                Components.TextField {
                    height: parent.height * 0.1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    placeholderText: "Current Password"
                }

                Components.TextField {
                    height: parent.height * 0.1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    placeholderText: "New Password"
                }

                Components.TextField {
                    height: parent.height * 0.1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    placeholderText: "Confirm New Password"
                }
            }
        }

        Components.BottomAction {
            Controls.Button  {
                anchors.fill: parent
                centerText: "Save settings"
            }
        }
    }
}
