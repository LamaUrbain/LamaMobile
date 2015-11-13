import QtQuick 2.5
import QtQuick.Controls 1.4
import "qrc:/Components/" as Components

Item {
    id: field
    height: 55

    property date selectedDate: new Date()
    property alias dateField: dateField
    property alias text: dateField.text

    function dateToString(date)
    {
        var str = date.toISOString();
        str = str.replace("T", " ");
        str = str.substring(0, Math.max(0, str.length - 5));
        return str;
    }

    Calendar {
        id: datePicker
        visible: false
        minimumDate: new Date()
        anchors {
            left: parent.left
            top: parent.bottom
            topMargin: 3
        }
        onDoubleClicked: {
            selectedDate = date;
            field.selectedDate = selectedDate;
            field.dateField.text = dateToString(selectedDate);
            visible = false;
        }
        onVisibleChanged: {
            if (visible)
                forceActiveFocus();
        }
        onFocusChanged: {
            if (!focus)
                visible = false;
        }
    }

    Components.TextField {
        id: dateField
        readOnly: true
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: datePicker.visible = true;
        }
    }
}
