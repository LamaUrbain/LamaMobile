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
            title: "User Feedback"
        }

        Components.Marker {
            id: options
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            height: parent.height * 0.1
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            Components.Marker {
                id: alertButton
                centerText: "Alert"
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width * 0.5
                height: parent.height
            }

            Components.Marker {
                id: bugButton
                centerText: "Bug Report"
                anchors.left: alertButton.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }

        Components.Marker {
            id: report
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: options.bottom
            height: parent.height * 0.7
            anchors.leftMargin: parent.height * 0.005
            anchors.rightMargin: parent.height * 0.005
            anchors.topMargin: parent.height * 0.005
            anchors.bottomMargin: parent.height * 0.005

            /*Components.Marker {
                id: mapReport
                centerText: "Alert On Map"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height
            }*/

            Components.Marker {
                id: bugReport
                centerText: "Bug report text"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height
            }
        }

        Components.BottomAction {
            id: sendReportButton
            centerText: "Send Report"
        }
    }
}


