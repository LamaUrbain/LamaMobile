import QtQuick 2.5
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Views/ViewsLogic.js" as ViewsLogic
import "qrc:/Constants.js" as Constants

Components.Background {
    color: Constants.LAMA_BACKGROUND2

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: "New incident"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            Components.FormEntry {
                id: nameForm
                fieldName: "Name"
                textFieldPlaceHolder: "Describe the incident"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormDateEntry {
                id: beginForm
                fieldName: "Begin date"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormDateEntry {
                id: endForm
                fieldName: "End date"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormEntry {
                id: addressForm
                fieldName: "Address"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Controls.NavigationButton {
            anchors.left: parent.left
            anchors.right: parent.right
            source: Constants.LAMA_INCIDENT_RESSOURCE
            text: "Report a new incident"
            acceptClick: false
            onNavButtonPressed:
            {
                console.log(addressForm)
                rootView.reportEvent(nameForm.textFieldText, beginForm.textFieldText, endForm.textFieldText, addressForm.textFieldText);
            }
        }
    }
}
