import QtQuick 2.0
import "qrc:/Constants.js" as Constants

Rectangle {
    id: menuSection
    anchors.left: parent.left
    anchors.right: parent.right
    property alias sectionTitle: sectionTitle.text
    property alias menuItemsModel: menuItems.model
    signal menuItemClicked(string qmlFileName)

    Rectangle
    {
        id: title
        anchors.left: parent.left
        anchors.right: parent.right
        height: Constants.fontSize * 1.2

        Text
        {
            id: sectionTitle
            anchors.left: parent.left
            font.pixelSize: Constants.fontSize
            height: parent.height
        }

        Rectangle
        {
            height: 5
            anchors.left: sectionTitle.right
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: anchors.leftMargin
            anchors.verticalCenter: parent.verticalCenter
            color: "#777"
        }
    }

    ListView
    {
        id: menuItems
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: title.bottom
        anchors.topMargin: menuSection.parent.height * 0.03
        anchors.bottom: parent.bottom
        anchors.leftMargin: menuSection.parent.width * 0.05
        spacing: anchors.topMargin
        delegate:
        Column
        {
            Row
            {
                spacing: menuSection.width * 0.06
                Image
                {
                    height: menuItems.anchors.topMargin * 2
                    width: height
                    source: "qrc:/Assets/Images/" + menuItemKey.toLowerCase() + "Icon.png"
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            menuSection.menuItemClicked(menuItemKey)
                        }
                    }
                }

                Text
                {
                    text: menuItemName
                    font.pixelSize: Constants.fontSize
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            menuSection.menuItemClicked(menuItemKey)
                        }
                    }
                }
            }
        }
    }
}

