import QtQuick 2.0

Item {
    id: popover

    x: baseX + parent.offsetX - anchorPoint.x
    y: baseY + parent.offsetY - anchorPoint.y
    width: sourceItem.width
    height: sourceItem.height

    property bool focusScope: false
    property point anchorPoint: Qt.point(sourceItem.width / 2, sourceItem.height)
    property point coordinate
    property QtObject sourceItem

    property int baseX: -1
    property int baseY: -1

    signal cancelRequest();

    onCoordinateChanged: updatePos();
    onVisibleChanged: {
        if (visible)
            updatePos();
    }

    Connections {
        target: popover.visible ? parent : null
        onMapCenterChanged: updatePos();
        onMapScaleChanged: updatePos();
    }

    MouseArea {
        z: -1
        parent: popover.parent
        enabled: popover.visible && popover.focusScope
        visible: enabled
        anchors.fill: parent
        onClicked: popover.cancelRequest();
    }

    function updatePos()
    {
        if (parent)
        {
            var pos = parent.toPosition(coordinate);
            baseX = pos.x;
            baseY = pos.y;
        }
    }
}
