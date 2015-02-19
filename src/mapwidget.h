#ifndef MAPWIDGET_H
#define MAPWIDGET_H

#include <QPixmap>
#include <QQuickPaintedItem>

#ifndef M_PI
#define M_PI    (3.14159265359)
#endif

class MapWidgetPrivate;
class MapExtension;

struct MapTile
{
    MapTile();
    MapTile(quint8 mscale, const QPoint &mpos, const QPixmap &mpixmap);
    MapTile(const MapTile &other);
    MapTile &operator=(const MapTile &other);
    ~MapTile();

    quint8 scale;
    QPoint pos;
    QPixmap pixmap;
};

class MapWidget : public QQuickPaintedItem
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(MapWidget)

    Q_PROPERTY(qreal mapScale READ getMapScale WRITE setMapScale NOTIFY mapScaleChanged)
    Q_PROPERTY(QPointF mapCenter READ getMapCenter WRITE setMapCenter NOTIFY mapCenterChanged)

public:
    MapWidget(QQuickItem *parent = 0);
    virtual ~MapWidget();

    void addTile(const MapTile &tile);
    void removeTile(const MapTile &tile);
    virtual void paint(QPainter *painter);

    const QList<MapExtension *> &getExtensions() const;
    void addExtension(MapExtension *ext);
    void removeExtension(MapExtension *ext);

    void repaint();

signals:
    void mapScaleChanged();
    void mapCenterChanged();
    void mapTileRequired();

public slots:
    quint8 getMapScale() const;
    void setMapScale(quint8 scale);

    const QPointF &getMapCenter() const;
    void setMapCenter(const QPointF &center);

    const QList<QPoint> &getMissingTiles() const;

protected:
    virtual void wheelEvent(QWheelEvent *event);
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);
    virtual void mouseMoveEvent(QMouseEvent *event);
    virtual void touchEvent(QTouchEvent *event);
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private:
    MapWidgetPrivate * const d_ptr;
};

#endif // MAPWIDGET_H
