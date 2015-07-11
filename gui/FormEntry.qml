import QtQuick 2.0
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Row {
    anchors.leftMargin: parent.height * 0.005
    anchors.rightMargin: parent.height * 0.005
    anchors.topMargin: parent.height * 0.005
    height: parent.height * 0.10

    property string fieldName
    property alias isPassword: formEntryText.isPassword
    property alias labelText: formEntryLabel.centerText
    property alias textFieldPlaceHolder: formEntryText.placeholderText
    property alias textFieldText: formEntryText.text

    onFieldNameChanged: {
        formEntryLabel.centerText = fieldName
        formEntryText.placeholderText = "Enter " + fieldName
    }

    Components.Marker {
        id: formEntryLabel
        centerText: "Label:"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.3
        height: parent.height * 0.5
        color: Constants.LAMA_ORANGE
    }

    Components.TextField {
        id: formEntryText
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.7
        opacity: 0.9
    }
}

