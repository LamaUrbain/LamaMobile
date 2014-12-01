#ifndef MAPWIDGETPRIVATE_H
#define MAPWIDGETPRIVATE_H

#include "mapwidget.h"
#include "quadtree.h"

class MapWidgetPrivate
{
    Q_DECLARE_PUBLIC(MapWidget)

public:
    MapWidgetPrivate(MapWidget *ptr);
    virtual ~MapWidgetPrivate();

    void displayChanged();

    void addTile(const MapTile &tile);
    void paint(QPainter *painter);

    quint8 getMapScale() const;
    void setMapScale(quint8 scale);

    const QPointF &getMapCenter() const;
    void setMapCenter(const QPointF &center);

    const QList<QPoint> &getMissingTiles() const;

    static QPoint posFromCoords(const QPointF &coords, quint8 scale);
    static QPointF coordsFromPos(const QPoint &pos, quint8 scale);
    static QSizeF tileSize(const QPoint &pos, quint8 scale);

private:
    void generateCache();
    void addMissingTiles(const QPoint &center, const QSize &size);
    void removeMissingTile(const QPoint &pos);

private:
    MapWidget * const q_ptr;
    Quadtree<MapTile> _quadtree;
    QPointF _center;
    quint8 _scale;
    bool _changed;
    QPixmap _cache;
    QList<QPoint> _missing;
};

#endif // MAPWIDGETPRIVATE_H
