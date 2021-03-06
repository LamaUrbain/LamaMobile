#ifndef MAPWIDGET_H
#define MAPWIDGET_H

#include <QImage>
#include <QQuickItem>
#include <QSGSimpleTextureNode>
#include <QTimer>

#ifndef M_PI
#define M_PI    (3.14159265359)
#endif

#ifndef MAP_EXTRA_SIZE
#define MAP_EXTRA_SIZE 1024
#endif
#ifndef MAP_EXTRA_SIZE_HALF
#define MAP_EXTRA_SIZE_HALF MAP_EXTRA_SIZE / 2
#endif

class MapWidgetPrivate;
class MapExtension;

typedef QImage MapPixmap;

struct MapTile
{
    MapTile();
    MapTile(quint8 mscale, const QPoint &mpos, const MapPixmap &mpixmap);
    MapTile(const MapTile &other);
    MapTile &operator=(const MapTile &other);
    ~MapTile();

    quint8 scale;
    QPoint pos;
    MapPixmap pixmap;
    QSGSimpleTextureNode *texture;
};

class MapWidget : public QQuickItem
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(MapWidget)

    Q_PROPERTY(int offsetX READ getOffsetX NOTIFY offsetXChanged)
    Q_PROPERTY(int offsetY READ getOffsetY NOTIFY offsetYChanged)
    Q_PROPERTY(qreal mapScale READ getMapScale WRITE setMapScale NOTIFY mapScaleChanged)
    Q_PROPERTY(QPointF mapCenter READ getMapCenter WRITE setMapCenter NOTIFY mapCenterChanged)
    Q_PROPERTY(int currentItinerary READ getCurrentItinerary NOTIFY currentItineraryChanged)

    friend class MapExtension;

public:
    MapWidget(QQuickItem *parent = 0);
    virtual ~MapWidget();

    void addTile(const MapTile &tile);
    void removeTile(const MapTile &tile);
    void removePendingTile(int scale, const QPoint &pos);

    const QList<MapExtension *> &getExtensions() const;
    void addExtension(MapExtension *ext);
    void removeExtension(MapExtension *ext);

    void repaint();

signals:
    void mapScaleChanged();
    void mapCenterChanged();
    void mapTileRequired();
    void mapPointClicked(QPoint pos, QPointF coords);
    void mapPointMoved(int id, int point, QPointF newCoords);
    void offsetXChanged();
    void offsetYChanged();
    void currentItineraryChanged();

public slots:
    int getCurrentItinerary() const;
    void displayItinerary(int id);
    void itineraryChanged();
    QList<QPointF> getItineraryPoints(int id) const;

    quint8 getMapScale() const;
    void setMapScale(quint8 scale);

    const QPointF &getMapCenter() const;
    void setMapCenter(const QPointF &center);

    int getOffsetX() const;
    int getOffsetY() const;
    QPointF toCoordinate(QPoint pos) const;
    QPoint toPosition(QPointF coord) const;

    const QList<QPoint> &getMissingTiles() const;

protected:
    virtual void wheelEvent(QWheelEvent *event);
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);
    virtual void mouseMoveEvent(QMouseEvent *event);
    virtual void touchEvent(QTouchEvent *event);
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    virtual QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *nodeData);

private:
    MapWidgetPrivate * const d_ptr;
};

#endif // MAPWIDGET_H
