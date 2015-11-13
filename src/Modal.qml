import QtQuick 2.0
import QtQuick.Layouts 1.2
import "qrc:/Controls/" as Controls
import "qrc:/Components" as Components
import "qrc:/Constants.js" as Constants

Components.MaskBackground {
    id: modalView
    visible: false

    onVisibleChanged: {
        if (visible)
        {
            focus = true;
            return;
        }
        modalSourceComponent = undefined;
    }

    Keys.onReturnPressed: {
        if (!loading)
            visible = false;
    }

    property bool loading: true
    property alias title: modalTitle.title
    property alias message: modalMessage.text
    property alias modalSourceComponent: modalLoader.sourceComponent

    Rectangle {
        anchors.fill: parent
        color: "#66000000"
    }

    Components.Background {
        anchors.centerIn: parent
        width: modalView.loading ? 300 : 500
        height: modalView.loading ? 300 : messageArea.height + 60
        radius: 15

        Components.LoadingRing {
            anchors.centerIn: parent
            visible: modalView.visible && modalView.loading
        }

        ColumnLayout {
            id: messageArea
            spacing: 20
            visible: modalView.visible && !modalView.loading
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 30
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }

            Components.Header {
                id: modalTitle
                title: ""
                autoBack: false
                onBackClicked: modalView.visible = false;
            }

            Components.Separator {
                isTopSeparator: true
                Layout.fillWidth: true
                Layout.preferredHeight: 11
            }

            Loader {
                id: modalLoader
                sourceComponent: undefined
                visible: modalView.modalSourceComponent
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Components.TextLabel {
                id: modalMessage
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                textFormat: Text.PlainText
                maximumLineCount: 6
                horizontalAlignment: Text.AlignHCenter
                visible: !modalView.modalSourceComponent
            }

            Components.Separator {
                isTopSeparator: false
                Layout.fillWidth: true
                Layout.preferredHeight: 11
            }

            Controls.NavigationButton {
                text: "Close"
                anchors.left: parent.left
                anchors.right: parent.right
                acceptClick: false
                onNavButtonPressed: modalView.visible = false;
            }
        }
    }
}
