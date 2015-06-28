import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Components.Background {

    Components.Header {
        id: header
        title: "User Feedback"
    }

    Row {
        id: options
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: parent.height * 0.1
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Controls.Button {
            id: alertButton
            centerText: "Alert"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.5
            onButtonClicked: {
                checked = true
                bugButton.checked = false
                reportLoader.sourceComponent = mapReport
            }
        }

        Controls.Button {
            id: bugButton
            centerText: "Bug Report"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.5
            onButtonClicked: {
                checked = true
                alertButton.checked = false
                reportLoader.sourceComponent = bugReport
            }
        }
    }

    Loader {
        id: reportLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: options.bottom
        height: parent.height * 0.7
        anchors.leftMargin: parent.height * 0.005
        anchors.rightMargin: parent.height * 0.005
        anchors.topMargin: parent.height * 0.005
        anchors.bottomMargin: parent.height * 0.005

        Component {
            id: mapReport
            Components.Marker {
                centerText: "Alert On Map"
            }
        }

        Component {
            id: bugReport
            Components.Marker {
                centerText: "Bug report text"
            }
        }
    }

    Components.BottomAction {
        Controls.NavigationButton {
            anchors.fill: parent
            centerText: "Send Report"
            navigationTarget: "Map"
        }
    }
}
