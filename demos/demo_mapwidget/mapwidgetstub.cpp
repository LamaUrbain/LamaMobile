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

    static const int tilesCount = 9;
    static MapTile tiles[tilesCount] =
    {
        MapTile(7, QPoint(65, 43), MapPixmap(":/images/1.png")),
        MapTile(7, QPoint(64, 43), MapPixmap(":/images/2.png")),
        MapTile(7, QPoint(64, 44), MapPixmap(":/images/3.png")),
        MapTile(7, QPoint(65, 44), MapPixmap(":/images/4.png")),
        MapTile(7, QPoint(63, 43), MapPixmap(":/images/5.png")),
        MapTile(7, QPoint(63, 44), MapPixmap(":/images/6.png")),
        MapTile(7, QPoint(66, 43), MapPixmap(":/images/7.png")),
        MapTile(7, QPoint(66, 44), MapPixmap(":/images/8.png")),
        MapTile(7, QPoint(64, 45), MapPixmap(":/images/9.png"))
    };

    for (int i = 0; i < tilesCount; ++i)
        view->addTile(tiles[i]);
}
