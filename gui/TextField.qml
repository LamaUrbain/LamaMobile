import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "qrc:/Constants.js" as Constants

TextField {
    id: textField

    property bool isPassword: false

    echoMode: isPassword ? TextInput.Password : TextInput.Normal
    placeholderText: isPassword == false ? "Text" : "Password"

    font.pointSize: Constants.LAMA_POINTSIZE

    style: TextFieldStyle {
        textColor: "black"
        background: Rectangle {
            radius: 20
            border.width: 1
            border.color: Constants.LAMA_YELLOW
            opacity: 0.9
        }
    }
}
