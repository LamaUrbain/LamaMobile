#ifndef MAPOVERLAYEXTENSION_H
#define MAPOVERLAYEXTENSION_H

#include "mapwidgetprivate.h"
#include "mapextension.h"

class MapOverlayExtension : public MapExtension
{
public:
    MapOverlayExtension(MapWidget *map);
    virtual ~MapOverlayExtension();

    void addTile(const MapTile &tile);
    void removeTile(const MapTile &tile);

    virtual void begin(QPainter *painter);
    virtual void drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos);
    virtual void end(QPainter *painter);

private:
    QHash<QPoint, MapTile> _tiles[20];
};

#endif // MAPOVERLAYEXTENSION_H
