#include "mapoverlayextension.h"

MapOverlayExtension::MapOverlayExtension(MapWidget *map)
    : MapExtension(map)
{
}

MapOverlayExtension::~MapOverlayExtension()
{
}

void MapOverlayExtension::addTile(const MapTile &tile)
{
    if (!tile.pixmap.isNull() && tile.pixmap.width() > 0 && tile.pixmap.height() > 0)
    {
        _tiles[tile.scale][tile.pos] = tile;
        _map->repaint();
    }
}

void MapOverlayExtension::removeTile(const MapTile &tile)
{
    _tiles[tile.scale].remove(tile.pos);
    _map->repaint();
}

void MapOverlayExtension::begin(QPainter *painter)
{
    Q_UNUSED(painter);
}

void MapOverlayExtension::drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos)
{
    const QHash<QPoint, MapTile>::const_iterator it = _tiles[_map->getMapScale()].find(pos);

    if (it != _tiles[_map->getMapScale()].end())
    {
        const MapTile &tile = it.value();
        painter->drawPixmap(tilePos, tile.pixmap);
    }
}

void MapOverlayExtension::end(QPainter *painter)
{
    Q_UNUSED(painter);
}
