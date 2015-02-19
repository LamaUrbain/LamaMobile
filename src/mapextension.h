#ifndef MAPEXTENSION
#define MAPEXTENSION

#include <QPainter>
#include <QPoint>

class MapWidget;

class MapExtension
{
public:
    MapExtension(MapWidget *map);
    virtual ~MapExtension();

    virtual void begin(QPainter *painter) = 0;
    virtual void drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos) = 0;
    virtual void end(QPainter *painter) = 0;

protected:
    MapWidget *_map;
};

#endif // MAPEXTENSION
