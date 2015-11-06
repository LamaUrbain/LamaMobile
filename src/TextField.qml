import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import App 1.0
import "qrc:/Constants.js" as Constants

TextField {
    id: textField
    height: 55

    property bool isPassword: false

    echoMode: isPassword ? TextInput.Password : TextInput.Normal
    placeholderText: isPassword == false ? "Text" : "Password"

    style: TextFieldStyle {
        textColor: Constants.LAMA_FONTCOLOR
        font.pixelSize: Constants.LAMA_PIXELSIZE
        font.family: control.echoMode == TextInput.Normal ? ApplicationFont.name : ""
        renderType: Text.QtRendering
        padding.left: 15
        padding.right: 15
        background: Rectangle {
            radius: 15
            border.width: 3
            border.color: Constants.LAMA_YELLOW
            Component.onCompleted:
            {
                textField.enabledChanged.connect(function () { color = textField.enabled ? "#FFF" : "#DDD" });
            }
        }
    }
}
