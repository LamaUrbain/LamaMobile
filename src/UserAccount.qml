import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {

    Components.Header {
        id: header
        title: "User Account Management"
    }

    Row {
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
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.75
        }

        Components.Marker {
            id: avatar
            centerText: "Avatar"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.25
        }
    }

    Column {
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
            color: Constants.LAMA_ORANGE
            centerText: "Change Password:"
            anchors.left: parent.left
            width: parent.height * 0.75
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005
        }

        Column {
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
