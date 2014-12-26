#ifndef MAPWIDGETPRIVATE_H
#define MAPWIDGETPRIVATE_H

#include <QHash>
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
    void removeTile(const MapTile &tile);
    void paint(QPainter *painter);

    quint8 getMapScale() const;
    void setMapScale(quint8 scale);

    const QPointF &getMapCenter() const;
    void setMapCenter(const QPointF &center);

    const QList<QPoint> &getMissingTiles() const;

    void wheel(int delta);

    static QPoint posFromCoords(const QPointF &coords, quint8 scale);
    static QPointF coordsFromPos(const QPoint &pos, quint8 scale);
    static QPoint pixelsFromCoords(const QPointF &coords, quint8 scale);
    static QSizeF tileSize(const QPoint &pos, quint8 scale);

private:
    void generateCache();
    void addMissingTiles(const QPoint &center, const QSize &size, const QPoint &offset);
    void removeMissingTile(const QPoint &pos);

private:
    MapWidget * const q_ptr;
    QHash<QPoint, MapTile> _tiles[20];
    QPointF _center;
    quint8 _scale;
    bool _changed;
    int _currentWheel;
    QPixmap _cache;
    QList<QPoint> _missing;
};

inline uint qHash(const QPoint &key)
{
    uint h1 = qHash(key.x());
    uint h2 = qHash(key.y());
    return ((h1 << 16) | (h1 >> 16)) ^ h2;
}

#endif // MAPWIDGETPRIVATE_H
