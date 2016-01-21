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
            property int selectedIndex: -1
            property QtObject selectedItem: null

            function resetSwap()
            {
                if (selectedIndex != -1 && selectedItem)
                    selectedItem.swapSelected = false;

                selectedIndex = -1;
                selectedItem = null;
            }

            function toggleTagForSwap(index, item)
            {
                if (selectedIndex == -1)
                {
                    selectedIndex = index;
                    selectedItem = item;
                }
                else if (selectedIndex == index)
                {
                    selectedIndex = -1;
                    selectedItem = null;
                }
                else if ((index == 0 || index - 1 < itinerary.destinations.count)
                         && (selectedIndex == 0 || selectedIndex - 1 < itinerary.destinations.count))
                {
                    var from = index == 0 ? itinerary.departure : itinerary.destinations.get(index - 1).address;
                    var dest = selectedIndex == 0 ? itinerary.departure : itinerary.destinations.get(selectedIndex - 1).address;

                    if (index == 0)
                        itinerary.departure = dest;
                    else
                        itinerary.destinations.setProperty(index - 1, "address", dest);

                    if (selectedIndex == 0)
                        itinerary.departure = from;
                    else
                        itinerary.destinations.setProperty(selectedIndex - 1, "address", from);

                    item.swapSelected = false;
                    resetSwap();
                }
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
                    onSwapRequest: searchListView.toggleTagForSwap(0, headerItem);
                }
            }
            delegate: Components.Waypoint {
                id: delegateItem
                waypointId: index
                address: model.address
                onDeleteRequest: { searchListView.resetSwap(); itinerary.destinations.remove(index); }
                onEditRequest: rootView.mainViewTo("Suggestions", false, { model: itinerary, destinationId: waypointId });
                onSwapRequest: searchListView.toggleTagForSwap(index + 1, delegateItem);
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
                    onClicked: { searchListView.resetSwap(); itinerary.destinations.append({address: ""}); }
                }
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
