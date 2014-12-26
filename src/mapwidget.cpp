#include <cmath>
#include <QPainter>
#include "mapwidget.h"
#include "mapwidgetprivate.h"

struct WhirlLessThan
{
    QPoint center;

    bool operator()(const QPoint &p1, const QPoint &p2)
    {
        if (p1 == p2)
            return false;

        int diff1 = qAbs(center.x() - p1.x()) + qAbs(center.y() - p1.y());
        int diff2 = qAbs(center.x() - p2.x()) + qAbs(center.y() - p2.y());

        if (diff1 < diff2)
            return true;

        return false;
    }

    bool operator()(const QuadtreeObject<MapTile> *p1, const QuadtreeObject<MapTile> *p2)
    {
        return this->operator()(p1->object.pos, p2->object.pos);
    }
};

MapWidgetPrivate::MapWidgetPrivate(MapWidget *ptr)
    : q_ptr(ptr),
      _center(2.3488000, 48.8534100),
      _scale(7),
      _changed(true),
      _currentWheel(0)
{
}

MapWidgetPrivate::~MapWidgetPrivate()
{
}

void MapWidgetPrivate::displayChanged()
{
    Q_Q(MapWidget);
    _changed = true;
    q->update();
}

void MapWidgetPrivate::addTile(const MapTile &tile)
{
    if (!tile.pixmap.isNull() && tile.pixmap.width() > 0 && tile.pixmap.height() > 0)
    {
        _tiles[tile.scale][tile.pos] = tile;
        displayChanged();
    }
}

void MapWidgetPrivate::removeTile(const MapTile &tile)
{
    _tiles[tile.scale].remove(tile.pos);
    displayChanged();
}

void MapWidgetPrivate::paint(QPainter *painter)
{
    Q_Q(const MapWidget);

    if (painter && q->width() > 0 && q->height() > 0 && _scale > 0)
    {
        if (_changed)
            generateCache();
        painter->fillRect(0, 0, q->width(), q->height(), Qt::white);
        painter->drawPixmap(0, 0, _cache);
    }
}

quint8 MapWidgetPrivate::getMapScale() const
{
    return _scale;
}

void MapWidgetPrivate::setMapScale(quint8 scale)
{
    if (scale != _scale)
    {
        Q_Q(MapWidget);
        _scale = scale;
        q->mapScaleChanged();
        displayChanged();
    }
}

const QPointF &MapWidgetPrivate::getMapCenter() const
{
    return _center;
}

void MapWidgetPrivate::wheel(int delta)
{
    if ((_currentWheel > 0 && delta < 0) || (_currentWheel < 0 && delta > 0))
        _currentWheel = 0;

    _currentWheel += delta;

    if (_currentWheel >= 120)
    {
        Q_Q(MapWidget);
        q->setMapScale(q->getMapScale() + 1);
        _currentWheel = 0;
    }
    else if (_currentWheel <= -120)
    {
        Q_Q(MapWidget);
        q->setMapScale(qMax<quint8>(1, q->getMapScale()) - 1);
        _currentWheel = 0;
    }
}

void MapWidgetPrivate::setMapCenter(const QPointF &center)
{
    if (_center != center)
    {
        Q_Q(MapWidget);
        _center = center;
        q->mapCenterChanged();
        displayChanged();
    }
}

const QList<QPoint> &MapWidgetPrivate::getMissingTiles() const
{
    return _missing;
}

void MapWidgetPrivate::generateCache()
{
    Q_Q(MapWidget);

    _missing.clear();

    // TODO: limiter les calculs (offset de décalage, position du centre)

    QSize size(q->width(), q->height());

    QPixmap pix(size);
    QPainter painter(&pix);
    painter.fillRect(0, 0, pix.width(), pix.height(), Qt::white);

    QPoint centerPos = MapWidgetPrivate::posFromCoords(_center, _scale);
    QPointF centerCoords = MapWidgetPrivate::coordsFromPos(centerPos, _scale);
    QPoint offset = MapWidgetPrivate::pixelsFromCoords(_center, _scale) - MapWidgetPrivate::pixelsFromCoords(centerCoords, _scale);
    QPoint centerPix = QPoint(size.width() / 2, size.height() / 2);

    addMissingTiles(centerPos, size, offset);

    foreach (QPoint pos, _missing)
    {
        const QHash<QPoint, MapTile>::const_iterator it = _tiles[_scale].find(pos);

        if (it != _tiles[_scale].end())
        {
            const MapTile &tile = it.value();

            QPoint tilePos;
            tilePos.setX(centerPix.x() - (centerPos.x() - tile.pos.x()) * 256 - offset.x());
            tilePos.setY(centerPix.y() - (centerPos.y() - tile.pos.y()) * 256 - offset.y());

            painter.drawPixmap(tilePos, tile.pixmap);
            removeMissingTile(pos);
        }
    }

    _cache = pix;
    _changed = false;

    if (!_missing.isEmpty())
        q->mapTileRequired();
}

void MapWidgetPrivate::addMissingTiles(const QPoint &center, const QSize &size, const QPoint &offset)
{
    QPoint centerPx = QPoint(size.width() / 2, size.height() / 2) - offset;

    int leftNbr = (int)ceil(centerPx.x() / 256.0);
    int rightNbr = (int)ceil((size.width() - centerPx.x()) / 256.0);
    int topNbr = (int)ceil(centerPx.y() / 256.0);
    int botNbr = (int)ceil((size.height() - centerPx.y()) / 256.0);

    int offsetX = qMax(0, center.x() - leftNbr);
    int offsetY = qMax(0, center.y() - topNbr);

    for (int j = 0; j < topNbr + botNbr; ++j)
        for (int i = 0; i < leftNbr + rightNbr; ++i)
            _missing.append(QPoint(offsetX + i, offsetY + j));

    WhirlLessThan cmp;
    cmp.center = center;
    qSort(_missing.begin(), _missing.end(), cmp);
}

void MapWidgetPrivate::removeMissingTile(const QPoint &pos)
{
    _missing.removeOne(pos);
}

QPoint MapWidgetPrivate::posFromCoords(const QPointF &coords, quint8 scale)
{
    // x = longitude
    // y = latitude

    QPoint pos;
    pos.setX((int)((coords.x() + 180.0) * pow(2.0, scale) / 360.0));
    pos.setY((int)((1.0 - log(tan(coords.y() * M_PI / 180.0) + 1.0 / cos(coords.y() * M_PI / 180.0)) / M_PI) / 2.0 * pow(2.0, scale)));

    return pos;
}

QPointF MapWidgetPrivate::coordsFromPos(const QPoint &pos, quint8 scale)
{
    // x = longitude
    // y = latitude

    qreal n = M_PI - 2.0 * M_PI * pos.y() / pow(2.0, scale);

    QPointF coords;
    coords.setX(pos.x() * 360.0 / pow(2.0, scale) - 180);
    coords.setY(180.0 * atan(0.5 * (exp(n) - exp(-n))) / M_PI);

    return coords;
}

QPoint MapWidgetPrivate::pixelsFromCoords(const QPointF &coords, quint8 scale)
{
    // x = longitude
    // y = latitude

    QPoint pixels;

    pixels.setX((int)((coords.x() + 180.0) * (pow(2.0, scale) * 256) / 360.0));
    pixels.setY((int)((1.0 - (log(tan(M_PI / 4.0 + coords.y() * M_PI / 180.0 / 2.0)) / M_PI)) / 2.0 * pow(2.0, scale) * 256));

    return pixels;
}

QSizeF MapWidgetPrivate::tileSize(const QPoint &pos, quint8 scale)
{
    // x = longitude
    // y = latitude

    QPointF current = MapWidgetPrivate::coordsFromPos(pos, scale);
    QPointF next = MapWidgetPrivate::coordsFromPos(QPoint(pos.x() + 1, pos.y() + 1), scale);

    QSizeF size;
    size.setWidth(qAbs(current.x() - next.x()));
    size.setHeight(qAbs(current.y() - next.y()));

    return size;
}

MapTile::MapTile()
{
}

MapTile::MapTile(quint8 mscale, const QPoint &mpos, const QPixmap &mpixmap)
    : scale(mscale), pos(mpos), pixmap(mpixmap)
{
}

MapTile::MapTile(const MapTile &other)
    : scale(other.scale), pos(other.pos), pixmap(other.pixmap)
{
}

MapTile &MapTile::operator=(const MapTile &other)
{
    scale = other.scale;
    pos = other.pos;
    pixmap = other.pixmap;
    return *this;
}

MapTile::~MapTile()
{
}

MapWidget::MapWidget(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      d_ptr(new MapWidgetPrivate(this))
{
}

MapWidget::~MapWidget()
{
    delete d_ptr;
}

void MapWidget::addTile(const MapTile &tile)
{
    Q_D(MapWidget);
    d->addTile(tile);
}

void MapWidget::removeTile(const MapTile &tile)
{
    Q_D(MapWidget);
    d->removeTile(tile);
}

void MapWidget::paint(QPainter *painter)
{
    Q_D(MapWidget);
    d->paint(painter);
}

quint8 MapWidget::getMapScale() const
{
    Q_D(const MapWidget);
    return d->getMapScale();
}

void MapWidget::setMapScale(quint8 scale)
{
    Q_D(MapWidget);
    d->setMapScale(qBound<quint8>(1, scale, 18));
}

const QPointF &MapWidget::getMapCenter() const
{
    Q_D(const MapWidget);
    return d->getMapCenter();
}

void MapWidget::setMapCenter(const QPointF &center)
{
    Q_D(MapWidget);
    d->setMapCenter(center);
}

void MapWidget::wheelEvent(QWheelEvent *event)
{
    QPoint delta = event->angleDelta();

    if (!delta.isNull())
    {
        Q_D(MapWidget);
        d->wheel(delta.y());
    }

    event->accept();
}

void MapWidget::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    if (newGeometry.size() != oldGeometry.size())
    {
        Q_D(MapWidget);
        d->displayChanged();
    }
    QQuickPaintedItem::geometryChanged(newGeometry, oldGeometry);
}

const QList<QPoint> &MapWidget::getMissingTiles() const
{
    Q_D(const MapWidget);
    return d->getMissingTiles();
}
