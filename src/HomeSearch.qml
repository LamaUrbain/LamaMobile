import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import App 1.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.Background {
    id: homeSearchView
    height: searchContents.height + 90
    width: 500
    radius: 15

    signal searchRequest(string departure);

    ColumnLayout {
        id: searchContents
        spacing: 30
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 30
            rightMargin: 30
            topMargin: 40
        }

        Item {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
            height: titleArea.height

            Item {
                height: 1
                width: 175
                anchors.bottom: parent.bottom

                Image {
                    source: Constants.LAMA_LOGO
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: -22
                    }
                }
            }

            ColumnLayout {
                id: titleArea
                spacing: 5
                anchors.right: parent.right

                Row {
                    Layout.alignment: Qt.AlignRight
                    height: childrenRect.height

                    Components.TextLabel {
                        text: "Lama "
                        color: Constants.LAMA_ORANGE
                        font.pixelSize: Constants.LAMA_PIXELSIZE_BIG
                        font.bold: true
                    }

                    Components.TextLabel {
                        text: "Urbain"
                        color: Constants.LAMA_YELLOW
                        font.pixelSize: Constants.LAMA_PIXELSIZE_BIG
                        font.bold: true
                    }
                }

                Components.TextLabel {
                    Layout.fillWidth: true
                    text: "The most open itinerary app ever"
                    font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                    color: Constants.LAMA_ORANGE
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            TextField {
                id: searchField
                Layout.fillWidth: true
                Layout.preferredHeight: 55
                echoMode: TextInput.Normal
                placeholderText: "Search"
                onAccepted: homeSearchView.searchRequest(searchField.text);

                style: TextFieldStyle {
                    textColor: Constants.LAMA_FONTCOLOR
                    font.pixelSize: Constants.LAMA_PIXELSIZE
                    font.family: ApplicationFont.name
                    renderType: Text.QtRendering
                    padding.left: 15
                    padding.right: 15
                    background: Item {
                        clip: true
                        Rectangle {
                            radius: 15
                            border.width: 3
                            border.color: Constants.LAMA_YELLOW
                            anchors.fill: parent
                            anchors.rightMargin: -20
                        }
                    }
                }
            }

            MouseArea {
                clip: true
                Layout.fillHeight: true
                Layout.preferredWidth: 80
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                onClicked: homeSearchView.searchRequest(searchField.text);

                Rectangle {
                    radius: 15
                    color: Constants.LAMA_YELLOW
                    anchors.fill: parent
                    anchors.leftMargin: -20
                }

                Image {
                    anchors.centerIn: parent
                    source: Constants.LAMA_SEARCH_RESSOURCE
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    width: 28
                    height: 28
                }
            }
        }
    }
}
