#ifndef MAPWIDGETPRIVATE_H
#define MAPWIDGETPRIVATE_H

#include <QHash>
#include <QSGTexture>
#include "mapwidget.h"
#include "quadtree.h"

class MapGetter;

class MapWidgetPrivate
{
    Q_DECLARE_PUBLIC(MapWidget)

    friend class MapExtension;

public:
    MapWidgetPrivate(MapWidget *ptr);
    virtual ~MapWidgetPrivate();

    void initialize();
    void displayChanged();
    void geometryChanged();

    void addTile(const MapTile &tile);
    void removeTile(const MapTile &tile);
    void removePendingTile(int scale, const QPoint &pos);

    quint8 getMapScale() const;
    void setMapScale(quint8 scale);

    const QPointF &getMapCenter() const;
    void setMapCenter(const QPointF &center);

    const QList<QPoint> &getMissingTiles() const;

    const QPoint &getScrollOffset() const;
    const QPoint &getCenterPos() const;
    const QPoint &getCenterOffset() const;

    void wheel(int delta);
    void mouseMove(const QPoint &pos);

    void wheelEvent(QWheelEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void touchEvent(QTouchEvent *event);
    QSGNode *updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *nodeData);

    QPointF posFromCoords(const QPointF &coords) const;
    QPointF coordsFromPos(const QPoint &pos) const;
    QPoint pixelsFromCoords(const QPointF &coords) const;
    QPointF coordsFromPixels(const QPoint &pos) const;
    QSizeF tileSize(const QPoint &pos) const;

    int getCurrentItinerary() const;
    void displayItinerary(int id);
    void itineraryChanged();
    QList<QPointF> getItineraryPoints(int id) const;

    const QList<MapExtension *> &getExtension() const;
    void addExtension(MapExtension *ext);
    void removeExtension(MapExtension *ext);

    MapGetter *getMapGetter() const;

private:
    void updateCenterValues();
    void updateCenter();
    void generateCache();
    void addMissingTiles(const QPoint &center, const QSize &size, const QPoint &offset);
    void removeMissingTile(const QPoint &pos);
    bool isTileVisible(const QPoint &tile) const;

private:
    MapWidget * const q_ptr;

    // Tiles
    QHash<QPoint, MapTile> _tiles[20];

    // Properties
    QPointF _center;
    quint8 _scale;

    // Generation
    QPoint _centerPos;
    QPoint _centerOffset;
    int _tilesNumber;

    // Scroll
    QPoint _scrollOffset;
    bool _scrollValueSet;
    QPoint _scrollLastPos;
    bool _wheeling;

    // Extensions
    int _id;
    QList<MapExtension *> _extensions;

    // Interactions
    QPoint _pressedPos;

    // Other
    bool _changed;
    int _currentWheel;
    MapPixmap _cache;
    QSGTexture *_texture;
    QList<QPoint> _missing;
    MapGetter *_mapGetter;
};

inline uint qHash(const QPoint &key)
{
    uint h1 = qHash(key.x());
    uint h2 = qHash(key.y());
    return ((h1 << 16) | (h1 >> 16)) ^ h2;
}

#endif // MAPWIDGETPRIVATE_H
