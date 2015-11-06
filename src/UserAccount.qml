import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants
import "qrc:/Views/ViewsLogic.js" as ViewsLogic

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
            title: "Settings"
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
                id: emailForm
                fieldName: "Email"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormEntry {
                id: passwordForm
                isPassword: true
                fieldName: "Password"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.FormEntry {
                id: passwordConfirmForm
                isPassword: true
                fieldName: "Confirm"
                textFieldPlaceHolder: "Confirm password"
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
            enabled: emailForm.textFieldText.length > 0 || passwordForm.textFieldText.length > 0
            source: Constants.LAMA_SETTINGS_RESSOURCE
            text: "Save your settings"
            acceptClick: false
            onNavButtonPressed:
            {
                var email = emailForm.textFieldText;
                var password = passwordForm.textFieldText;
                var confirm = passwordConfirmForm.textFieldText;

                if (password && ViewsLogic.checkPassword(password, confirm) != false)
                {
                    rootView.modal.loading = false;
                    rootView.modal.title = "Error"
                    rootView.modal.message = "Invalid password or both passwords do not match."
                    rootView.modal.visible = true;
                }
                else if (email && ViewsLogic.checkMail(email) != false)
                {
                    rootView.modal.loading = false;
                    rootView.modal.title = "Error"
                    rootView.modal.message = "Invalid email."
                    rootView.modal.visible = true;
                }
                else
                    rootView.editAccount(password, email);
            }
        }
    }
}
