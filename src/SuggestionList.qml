import QtQuick 2.5
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Column {
    id: suggestionList
    spacing: 10
    anchors {
        left: parent.left
        right: parent.right
    }

    property bool hasIcon: true
    property alias model: repeater.model

    signal selectionRequest(string address);

    Repeater {
        id: repeater
        anchors {
            left: parent.left
            right: parent.right
        }
        delegate: Item {
            width: repeater.width
            height: 25

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Item {
                    visible: suggestionList.hasIcon
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 20

                    Image {
                        source: model.icon
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Components.TextLabel {
                    Layout.fillWidth: model.address ? false : true
                    text: model.title + " "
                    font.bold: model.address ? true : false
                    font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
                    elide: Text.ElideRight
                }

                Components.TextLabel {
                    visible: text != ""
                    Layout.fillWidth: true
                    text: model.address
                    font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM - 2
                    elide: Text.ElideRight
                    opacity: 0.6
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (model.address.length > 0)
                        suggestionList.selectionRequest(model.address);
                    else
                        suggestionList.selectionRequest(model.title);
                }
            }
        }
    }
}
