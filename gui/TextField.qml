import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "qrc:/Constants.js" as Constants

Marker {
    property alias placeholderText: textField.placeholderText
    property bool isPassword: false

    TextField {
        id: textField
        anchors.fill: parent
        echoMode: isPassword ? TextInput.Password : TextInput.Normal
        opacity: 0.9
        placeholderText: isPassword ? "Text" : "Password"
        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                radius: 20
                border.width: 1
                border.color: Constants.LAMA_YELLOW
            }
        }
    }
}
