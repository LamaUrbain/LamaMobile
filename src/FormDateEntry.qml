import QtQuick 2.5
import QtQuick.Layouts 1.1
import "qrc:/Components/" as Components

Column {
    spacing: 15

    property string fieldName
    property alias labelText: formEntryLabel.text
    property string textFieldPlaceHolder: "Select " + fieldName.toLowerCase()
    property alias textFieldText: formEntryText.text

    Components.TextLabel {
        id: formEntryLabel
        text: fieldName
    }

    Components.DateField {
        id: formEntryText
        dateField.placeholderText: textFieldPlaceHolder
        height: 55
        anchors {
            left: parent.left
            right: parent.right
        }
    }
}
