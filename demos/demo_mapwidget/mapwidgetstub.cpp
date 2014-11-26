#include "mapwidgetstub.h"
#include "mapwidget.h"

MapWidgetStub::MapWidgetStub(QObject *parent)
    : QObject(parent)
{
}

void MapWidgetStub::initMapWidget(MapWidget *view)
{
    if (!view)
        return;

    static const int tilesCount = 8;
    static MapTile tiles[tilesCount] =
    {
        MapTile(7, QPoint(65, 43), QPixmap(":/images/1.png")),
        MapTile(7, QPoint(64, 43), QPixmap(":/images/2.png")),
        MapTile(7, QPoint(64, 44), QPixmap(":/images/3.png")),
        MapTile(7, QPoint(65, 44), QPixmap(":/images/4.png")),
        MapTile(7, QPoint(63, 43), QPixmap(":/images/5.png")),
        MapTile(7, QPoint(63, 44), QPixmap(":/images/6.png")),
        MapTile(7, QPoint(66, 43), QPixmap(":/images/7.png")),
        MapTile(7, QPoint(66, 44), QPixmap(":/images/8.png")),
    };

    for (int i = 0; i < tilesCount; ++i)
        view->addTile(tiles[i]);
}
