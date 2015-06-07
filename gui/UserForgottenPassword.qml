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
                id: emailForm
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                fieldName: "Email"
            }

        }

        Components.BottomAction {
            Controls.NavigationButton {
                anchors.fill: parent
                centerText: "Ask for a new password"
                navigationTarget: "UserAuth"
            }
        }
    }
}
