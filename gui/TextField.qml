import QtQuick 2.0
import QtQuick.Controls 1.3

Marker {
    property alias placeholderText: textField.placeholderText
    property bool isPassword: false

    TextField {
        id: textField
        anchors.fill: parent
        echoMode: isPassword ? TextInput.Password : TextInput.Normal
        opacity: 0.9
        placeholderText: isPassword ? "Text" : "Password"
    }
}
