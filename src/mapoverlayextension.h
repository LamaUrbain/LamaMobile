#ifndef MAPOVERLAYEXTENSION_H
#define MAPOVERLAYEXTENSION_H

#include <QMultiHash>
#include "mapwidgetprivate.h"
#include "mapextension.h"

class MapOverlayExtension : public MapExtension
{
    Q_OBJECT

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

    virtual bool mousePressEvent(QMouseEvent *event);
    virtual bool mouseReleaseEvent(QMouseEvent *event);
    virtual bool mouseMoveEvent(QMouseEvent *event);

signals:
    void pointMoved(int point, QPointF newCoords);

private:
    void onTilesChanged();
    void generateTilePoints(quint8 scale);
    int pointAt(const QPoint &pos) const;

private:
    typedef QPair<QPointF, int> PairPointF;
    typedef QPair<QPoint, int> PairPoint;

    QHash<QPoint, MapTile> _tiles[20];
    QMultiHash<QPoint, PairPointF> _tilePoints[20];
    QList<QPointF> _points;
    QList<PairPoint> _pending;
    QPixmap _indicator;
    QPixmap _selectedIndicator;
    int _selectedPoint;
};

#endif // MAPOVERLAYEXTENSION_H
