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
        nameField.text = itinerary.name ? itinerary.name : "";
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
            title: "Search"
        }

        Components.Separator {
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Components.TextField {
            id: nameField
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            placeholderText: "Change itinerary name"
            font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
            onTextChanged: itinerary.name = text;
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        ListView {
            property bool canSwap: false
            property var waypoint_swap: [null, null]
            property int waypoint_swapSwitch: 0

            function swapWaypoints()
            {
                if (!canSwap)
                    return;

                rootView.modal.loading = true;
                rootView.modal.title = "Swaping..."
                rootView.modal.message = ""
                rootView.modal.visible = true;

                var then = function (obj)
                {
                    if (obj !== null)
                    {
                        var swap = waypoint_swap[0].address;
                        waypoint_swap[0].address = waypoint_swap[1].address;
                        waypoint_swap[1].address = swap;
                        swap = waypoint_swap[0].waypointId;
                        waypoint_swap[0].waypointId = waypoint_swap[1].waypointId;
                        waypoint_swap[1].waypointId = swap;

                        waypoint_swap[0].swapSelected = false;
                        waypoint_swap[0] = null;
                        waypoint_swap[1].swapSelected = false;
                        waypoint_swap[1] = null;
                        rootView.modal.visible = false; // paranoia
                    }
                    else
                    {
                        rootView.modal.message = "We could not swap the waypoints :(";
                        rootView.modal.loading = false;
                    }
                }
                rootView.swapDestinations(waypoint_swap[0].waypointId, waypoint_swap[1].waypointId, then);
            }

            function toggleTagForSwap(model)
            {
                if (model.swapSelected === false)
                {
                    if (waypoint_swap[0] === model)
                        waypoint_swap[(waypoint_swapSwitch = 0)] = null;
                    else
                        waypoint_swap[(waypoint_swapSwitch = 1)] = null;
                }
                else
                {
                    if (waypoint_swap[waypoint_swapSwitch] !== null)
                        waypoint_swap[waypoint_swapSwitch].swapSelected = false;
                    waypoint_swap[waypoint_swapSwitch] = model;
                    waypoint_swapSwitch = !waypoint_swapSwitch;
                }
                canSwap = waypoint_swap[0] !== null && waypoint_swap[1] !== null;
            }

            id: searchListView
            clip: true
            spacing: 8
            model: itinerary.destinations
            Layout.fillWidth: true
            Layout.fillHeight: true
            header: Item {
                height: headerItem.height + 9
                anchors {
                    left: parent.left
                    right: parent.right
                }
                Components.Waypoint {
                    id: headerItem
                    isDeparture: true
                    waypointId: -1
                    address: itinerary.departure
                    onEditRequest: rootView.mainViewTo("Suggestions", false, { model: itinerary, destinationId: waypointId });
                    anchors {
                        top: parent.top
                        topMargin: 1
                    }
                    onSwapRequest: searchListView.toggleTagForSwap(headerItem);
                }
            }
            delegate: Components.Waypoint {
                id: delegateItem
                waypointId: index
                address: model.address
                onDeleteRequest: itinerary.destinations.remove(index);
                onEditRequest: rootView.mainViewTo("Suggestions", false, { model: itinerary, destinationId: waypointId });
                onSwapRequest: searchListView.toggleTagForSwap(delegateItem);
            }
            footer: Item {
                height: footerItem.height + (searchListView.model.count == 0 ? 2 : 10)
                anchors {
                    left: parent.left
                    right: parent.right
                }
                Controls.Button {
                    id: footerItem
                    width: 75
                    height: 75
                    image.width: 50
                    image.height: 50
                    anchors.bottom: parent.bottom
                    source: Constants.LAMA_ADD_RESSOURCE
                    onClicked: itinerary.destinations.append({address: ""});
                }
            }
        }

        Rectangle {
            anchors.bottom: bottomSeparator.top
            height: 100
            Layout.fillWidth: true
            color: "transparent"
            visible: searchListView.canSwap
            Controls.Button
            {
                anchors.fill: parent;
                anchors.margins: 30

                Components.TextLabel {
                    text: "Swap waypoints !"
                    color: "#FFF"
                    font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
                    anchors.centerIn: parent
                }
                onClicked: searchListView.swapWaypoints()
            }
        }

        Components.Separator {
            id: bottomSeparator
            isTopSeparator: false
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Column {
            spacing: 15
            anchors {
                left: parent.left
                right: parent.right
            }

            Controls.NavigationButton {
                id: navButton
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_SEARCH_RESSOURCE
                text: "Search"
                navigationTarget: "Map"
                acceptClick: false
                onNavButtonPressed: rootView.mainSearch(itinerary.toObject());
            }

            RowLayout {
                height: sharedButton.height
                spacing: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Controls.NavigationButton {
                    visible: itinerary.owner
                    text: "Favorite"
                    primary: false
                    source: itinerary.favorite ? Constants.LAMA_SAVED_RESSOURCE : Constants.LAMA_SAVE_RESSOURCE
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Layout.fillWidth: true
                    acceptClick: false
                    onNavButtonPressed: itinerary.favorite = !itinerary.favorite;
                }

                Controls.ShareButton {
                    id: sharedButton
                    primary: false
                    Layout.fillWidth: true
                    itineraryId: itinerary.id
                }
            }
        }
    }
}
