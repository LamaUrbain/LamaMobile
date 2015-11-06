import QtQuick 2.5

Item {
    property bool isTopSeparator: true

    Rectangle {
        height: 1
        color: "#22000000"
        anchors {
            left: parent.left
            right: parent.right
            bottom: isTopSeparator ? parent.bottom : undefined
            top: !isTopSeparator ? parent.top : undefined
            leftMargin: -15
            rightMargin: -15
        }
    }
}
