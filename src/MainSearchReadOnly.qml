import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    color: Constants.LAMA_BACKGROUND2
    Component.onCompleted: {
        itinerary.copy(rootView.currentItinerary);
    }

    Components.Itinerary { id: itinerary }

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: (itinerary.name ? itinerary.name : "An itinerary") + " "
            titleSecondary: itinerary.owner ? "by " + itinerary.owner : ""
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        ListView {
            id: searchListView
            clip: true
            spacing: 10
            model: itinerary.destinations
            Layout.fillWidth: true
            Layout.fillHeight: true
            header: Item {
                height: headerItem.height + 9
                anchors {
                    left: parent.left
                    right: parent.right
                }
                Column {
                    id: headerItem
                    spacing: 10
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Components.TextLabel {
                        id: fromArea
                        visible: itinerary.destinations.count > 0
                        text: "From"
                        color: Constants.LAMA_ORANGE
                    }

                    Item {
                        height: childrenRect.height
                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        Image {
                            source: "qrc:/Images/departure.png"
                            anchors {
                                left: parent.left
                                leftMargin: 18
                            }
                        }

                        Components.TextLabel {
                            text: itinerary.departure
                            font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                            wrapMode: Text.Wrap
                            anchors {
                                left: parent.left
                                right: parent.right
                                leftMargin: 80
                            }
                        }
                    }

                    Components.TextLabel {
                        visible: itinerary.destinations.count > 0
                        text: "To"
                        color: Constants.LAMA_ORANGE
                        horizontalAlignment: Text.AlignHCenter
                        anchors {
                            left: fromArea.left
                            right: fromArea.right
                        }
                    }
                }
            }
            delegate: Item {
                height: itinerary.destinations.count > 1 ? destinationArea.height : childrenRect.height
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Image {
                    visible: index == 0
                    source: index == 0 ? "qrc:/Images/arrival.png" : ""
                    anchors {
                        left: parent.left
                        leftMargin: 18
                    }
                }

                Components.TextLabel {
                    id: destinationArea
                    text: (index + 1) + ".   " + address
                    font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                    wrapMode: Text.Wrap
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 80
                    }
                }
            }
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Controls.ShareButton {
            primary: true
            itineraryId: itinerary.id
            anchors {
                left: parent.left
                right: parent.right
            }
        }
    }
}
