import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtPositioning 5.5
import QtLocation 5.5
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background {
    id: suggestionsView
    color: Constants.LAMA_BACKGROUND2

    property QtObject model: null
    property int destinationId: -1

    function validate()
    {
        if (addressTextField.text.length > 1)
        {
            if (model)
            {
                if (destinationId < 0)
                    model.departure = addressTextField.text;
                else if (destinationId < model.destinations.count)
                    model.destinations.set(destinationId, { address: addressTextField.text });
            }
            rootView.mainViewBack();
        }
    }

    Component.onCompleted: {
        var position = rootView.mapView.getCurrentPosition();
        placeSearchModel.searchArea = QtPositioning.circle(QtPositioning.coordinate(position.y, position.x), 10000);

        if (model)
        {
            if (destinationId < 0)
            {
                header.title = "Departure";
                addressTextField.text = model.departure;
            }
            else
            {
                header.title = "Destination n°" + (destinationId + 1);
                var destination = model.destinations.get(destinationId);
                if (destination)
                    addressTextField.text = destination.address;
            }
            addressTextField.cursorPosition = 0;
        }
        addressTextField.forceActiveFocus();
    }

    Timer {
        id: suggestionTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: {
            var address = addressTextField.text;
            if (address.length >= 3) {
                geocodeModel.reset();
                geocodeModel.query = address;
                geocodeModel.update();
                placeSearchModel.reset();
                placeSearchModel.searchTerm = address;
                placeSearchModel.update();
            }
        }
    }

    ListModel { id: addressModel }
    ListModel { id: placeModel }

    GeocodeModel {
        id: geocodeModel
        plugin: geoPlugin
        limit: 4

        onStatusChanged: {
            if (status === GeocodeModel.Ready)
            {
                addressModel.clear();

                for (var i = 0; i < count && addressModel.count < limit; ++i)
                {
                    var location = get(i);

                    if (!location || location.address.country != "France")
                        continue;

                    var address = String(location.address.text).replace(/[<]br[^>]*[>]/gi, ", ");

                    var place = {
                        title: address,
                        address: "",
                        icon: ""
                    };

                    if (place.title)
                    {
                        console.debug("geoaddress [%1/%2]".arg(i + 1).arg(count), place.address);
                        addressModel.append(place);
                    }
                }
            }
            else if (status === GeocodeModel.Error)
                addressModel.clear();
        }
    }

    PlaceSearchModel {
        id: placeSearchModel
        plugin: geoPlugin
        limit: 4

        onStatusChanged: {
            if (status === PlaceSearchModel.Ready)
            {
                placeModel.clear();

                for (var i = 0; i < count && placeModel.count < limit; ++i)
                {
                    if (data(i, "type") !== PlaceSearchModel.PlaceResult)
                        continue;

                    var p = data(i, "place").location.address;
                    var address = String(p.text.length > 0 ? p.text : p.street).replace(/[<]br[^>]*[>]/gi, ", ");

                    var place = {
                        title: data(i, "title"),
                        address: address,
                        icon: data(i, "icon").url().toString()
                    };

                    if (place.title !== "" && place.address)
                    {
                        console.debug("place [%1/%2]".arg(i + 1).arg(count), JSON.stringify(place));
                        placeModel.append(place);
                    }
                }
            }
            else if (status === PlaceSearchModel.Error)
                placeModel.clear();
        }
    }

    ColumnLayout {
        id: contents
        spacing: 20
        anchors {
            fill: parent
            margins: 30
        }

        Components.Header {
            id: header
            title: "Address"
        }

        Components.Separator {
            isTopSeparator: true
            Layout.fillWidth: true
            Layout.preferredHeight: 11
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                id: addressArea
                height: 50
                spacing: 15
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Components.TextField {
                    id: addressTextField
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    placeholderText: "Enter address"
                    font.pixelSize: Constants.LAMA_PIXELSIZE_MEDIUM
                    onAccepted: suggestionsView.validate();
                    onTextChanged: suggestionTimer.restart();
                }

                Controls.DeleteButton {
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    onDeleted: addressTextField.text = "";
                }
            }

            Flickable {
                clip: true
                contentWidth: width
                contentHeight: Math.min(height, suggestionArea.height)
                anchors {
                    top: addressArea.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    topMargin: 35
                }

                Column {
                    id: suggestionArea
                    spacing: 25
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Components.TextLabel {
                        visible: addressModel.count > 0
                        text: "Suggestions"
                        color: Constants.LAMA_ORANGE
                        font.pixelSize: Constants.LAMA_PIXELSIZE + 4
                        font.bold: true
                    }

                    Components.SuggestionList {
                        model: addressModel
                        spacing: 8
                        hasIcon: false
                        onSelectionRequest: addressTextField.text = address;
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Components.TextLabel {
                        visible: placeModel.count > 0
                        text: "Nearby places"
                        color: Constants.LAMA_ORANGE
                        font.pixelSize: Constants.LAMA_PIXELSIZE + 4
                        font.bold: true
                    }

                    Components.SuggestionList {
                        model: placeModel
                        spacing: 8
                        onSelectionRequest: addressTextField.text = address;
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                }
            }
        }

        Components.Separator {
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
                enabled: addressTextField.text.length > 0
                anchors.left: parent.left
                anchors.right: parent.right
                source: Constants.LAMA_ADDRESS_RESSOURCE
                text: "Validate"
                acceptClick: false
                onNavButtonPressed: suggestionsView.validate();
            }
        }
    }
}
