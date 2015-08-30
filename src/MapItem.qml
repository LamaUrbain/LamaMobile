import QtQuick 2.0

Item {
    id: popover

    x: baseX + parent.offsetX - anchorPoint.x
    y: baseY + parent.offsetY - anchorPoint.y
    width: sourceItem.width
    height: sourceItem.height

    property point anchorPoint: Qt.point(sourceItem.width / 2, sourceItem.height)
    property point coordinate
    property QtObject sourceItem

    property int baseX: -1
    property int baseY: -1

    onCoordinateChanged: updatePos();

    Connections {
        target: parent
        onMapCenterChanged: updatePos();
        onMapScaleChanged: updatePos();
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
