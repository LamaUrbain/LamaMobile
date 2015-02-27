#ifndef MAPOVERLAYEXTENSION_H
#define MAPOVERLAYEXTENSION_H

#include <QMultiHash>
#include "mapwidgetprivate.h"
#include "mapextension.h"

class MapOverlayExtension : public MapExtension
{
public:
    MapOverlayExtension(MapWidget *map);
    virtual ~MapOverlayExtension();

    void addTile(const MapTile &tile);
    void removeTile(const MapTile &tile);

    const QList<QPointF> &getPoints() const;
    void appendPoint(const QPointF &coords);
    void prependPoint(const QPointF &coords);
    void insertPoint(int pos, const QPointF &coords);
    void movePoint(int pos, const QPointF &coords);
    void removePoint(int pos);

    virtual void begin(QPainter *painter);
    virtual void drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos);
    virtual void end(QPainter *painter);

private:
    void onTilesChanged();
    void generateTilePoints(quint8 scale);

private:
    QHash<QPoint, MapTile> _tiles[20];
    QMultiHash<QPoint, QPointF> _tilePoints[20];
    QList<QPointF> _points;
    QPixmap _indicator;
};

#endif // MAPOVERLAYEXTENSION_H
