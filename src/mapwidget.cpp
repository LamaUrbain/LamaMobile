#include <cmath>
#include <QPainter>
#include "mapwidget.h"
#include "mapwidgetprivate.h"
#include "mapgetter.h"
#include "mapextension.h"
#include "mapoverlayextension.h"

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
      _center(2.3358000, 48.8534100),
      _scale(12),
      _scrollOffset(-256, -256),
      _scrollValueSet(false),
      _wheeling(false),
      _changed(true),
      _currentWheel(0),
      _mapGetter(new MapGetter)
{
    Q_Q(MapWidget);

    q->setAcceptedMouseButtons(Qt::LeftButton);
    q->setRenderTarget(QQuickPaintedItem::FramebufferObject);
    q->setOpaquePainting(true);
    q->setFillColor(Qt::white);

    _tilesNumber = pow(2.0, _scale);
    updateCenterValues();
}

MapWidgetPrivate::~MapWidgetPrivate()
{
    qDeleteAll(_extensions);
    _extensions.clear();
}

void MapWidgetPrivate::initialize()
{
    Q_Q(MapWidget);
    _mapGetter->setWidget(q);
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
        painter->drawPixmap(_scrollOffset, _cache);
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
        updateCenter();
        _scale = scale;
        _tilesNumber = pow(2.0, scale);
        updateCenterValues();
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

void MapWidgetPrivate::mouseMove(const QPoint &pos)
{
    Q_Q(MapWidget);

    if (!_scrollValueSet)
    {
        _scrollValueSet = true;
        _scrollLastPos = pos;
    }
    else
    {
        int xDiff = _scrollLastPos.x() - pos.x();
        int yDiff = _scrollLastPos.y() - pos.y();

        _scrollOffset.rx() -= xDiff;
        _scrollOffset.ry() -= yDiff;
        _scrollLastPos = pos;

        if (_centerPos.x() * 256 + _centerOffset.x() - _scrollOffset.x() - 256 < 0)
            _scrollOffset.setX(_centerPos.x() * 256 + _centerOffset.x() - 256);
        else if (_centerPos.x() * 256 + _centerOffset.x() - _scrollOffset.x() - 256 > _tilesNumber * 256)
            _scrollOffset.setX(_centerPos.x() * 256 + _centerOffset.x() - 256 - _tilesNumber * 256);

        if (_centerPos.y() * 256 + _centerOffset.y() - _scrollOffset.y() - 256 < 0)
            _scrollOffset.setY(_centerPos.y() * 256 + _centerOffset.y() - 256);
        else if (_centerPos.y() * 256 + _centerOffset.y() - _scrollOffset.y() - 256 > _tilesNumber * 256)
            _scrollOffset.setY(_centerPos.y() * 256 + _centerOffset.y() - 256 - _tilesNumber * 256);

        if (_scrollOffset.x() <= -512 || _scrollOffset.x() >= 0
            || _scrollOffset.y() <= -512 || _scrollOffset.y() >= 0)
        {
            updateCenter();
        }

        q->update();
    }
}

void MapWidgetPrivate::wheelEvent(QWheelEvent *event)
{
    foreach (MapExtension *ext, _extensions)
        if (ext->wheelEvent(event))
        {
            event->accept();
            return;
        }

    QPoint delta = event->angleDelta();

    if (!delta.isNull())
        wheel(delta.y());

    event->accept();
}

void MapWidgetPrivate::mousePressEvent(QMouseEvent *event)
{
    foreach (MapExtension *ext, _extensions)
        if (ext->mousePressEvent(event))
        {
            event->accept();
            return;
        }

    event->accept();
}

void MapWidgetPrivate::mouseReleaseEvent(QMouseEvent *event)
{
    foreach (MapExtension *ext, _extensions)
        if (ext->mouseReleaseEvent(event))
        {
            event->accept();
            return;
        }

    _scrollValueSet = false;
    event->accept();
}

void MapWidgetPrivate::mouseMoveEvent(QMouseEvent *event)
{
    foreach (MapExtension *ext, _extensions)
        if (ext->mouseMoveEvent(event))
        {
            event->accept();
            return;
        }

    mouseMove(event->pos());
    event->accept();
}

void MapWidgetPrivate::touchEvent(QTouchEvent *event)
{
    foreach (MapExtension *ext, _extensions)
        if (ext->touchEvent(event))
        {
            event->accept();
            return;
        }

    switch (event->type())
    {
        case QEvent::TouchBegin:
        case QEvent::TouchUpdate:
        case QEvent::TouchEnd:
        {
            const QList<QTouchEvent::TouchPoint> &points = event->touchPoints();

            if (points.size() == 2)
            {
                const QTouchEvent::TouchPoint &p0 = points.first();
                const QTouchEvent::TouchPoint &p1 = points.last();

                qreal scale = QLineF(p0.pos(), p1.pos()).length() / QLineF(p0.startPos(), p1.startPos()).length();

                if (scale > 2.0)
                {
                    if (!_wheeling)
                        wheel(120);
                    _wheeling = true;
                }
                else if (scale < 0.6)
                {
                    if (!_wheeling)
                        wheel(-120);
                    _wheeling = true;
                }

                event->accept();
                return;
            }

            break;
        }
        default:
            break;
    }

    event->ignore();
    _wheeling = false;
}

void MapWidgetPrivate::setMapCenter(const QPointF &center)
{
    QPointF tmp(center);

    if (tmp.x() > 180.0)
        tmp.setX(180.0);
    else if (tmp.x() < -180.0)
        tmp.setX(-180.0);

    if (tmp.y() > 85.0511)
        tmp.setY(85.0511);
    else if (tmp.y() < -85.0511)
        tmp.setY(-85.0511);

    if (_center != tmp)
    {
        Q_Q(MapWidget);
        _center = tmp;
        updateCenterValues();
        q->mapCenterChanged();
        displayChanged();
    }
}

const QList<QPoint> &MapWidgetPrivate::getMissingTiles() const
{
    return _missing;
}

const QPoint &MapWidgetPrivate::getScrollOffset() const
{
    return _scrollOffset;
}

const QPoint &MapWidgetPrivate::getCenterPos() const
{
    return _centerPos;
}

const QPoint &MapWidgetPrivate::getCenterOffset() const
{
    return _centerOffset;
}

void MapWidgetPrivate::updateCenterValues()
{
    QPointF centerPos = posFromCoords(_center);
    _centerPos = QPoint((int)centerPos.x(), (int)centerPos.y());
    _centerOffset = pixelsFromCoords(_center) - pixelsFromCoords(coordsFromPos(_centerPos));
}

void MapWidgetPrivate::updateCenter()
{
    int xOffset = _scrollOffset.x() + 256;
    int yOffset = _scrollOffset.y() + 256;

    if (xOffset != 0 && yOffset != 0)
    {
        QPoint pos;

        pos.setX(_centerPos.x() * 256 + _centerOffset.x() - xOffset);
        pos.setY(_centerPos.y() * 256 + _centerOffset.y() - yOffset);

        setMapCenter(coordsFromPixels(pos));
    }

    _scrollOffset = QPoint(-256, -256);
}

void MapWidgetPrivate::generateCache()
{
    Q_Q(MapWidget);

    _missing.clear();

    QSize size(q->width() + 512, q->height() + 512);
    QPoint centerPix(size.width() / 2, size.height() / 2);

    if (_cache.size() != size)
        _cache = QPixmap(size);

    QPainter painter(&_cache);

    foreach (MapExtension *ext, _extensions)
        ext->begin(&painter);

    addMissingTiles(_centerPos, size, _centerOffset);

    foreach (QPoint pos, _missing)
    {
        const QHash<QPoint, MapTile>::const_iterator it = _tiles[_scale].find(pos);

        QPoint tilePos;
        tilePos.setX(centerPix.x() - (_centerPos.x() - pos.x()) * 256 - _centerOffset.x());
        tilePos.setY(centerPix.y() - (_centerPos.y() - pos.y()) * 256 - _centerOffset.y());

        if (it != _tiles[_scale].end())
        {
            const MapTile &tile = it.value();

            painter.drawPixmap(tilePos, tile.pixmap);
            removeMissingTile(pos);

            foreach (MapExtension *ext, _extensions)
                ext->drawTile(&painter, pos, tilePos);
        }
        else
            painter.fillRect(tilePos.x(), tilePos.y(), 256, 256, Qt::white);
    }

    foreach (MapExtension *ext, _extensions)
        ext->end(&painter);

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

    for (int j = 0; j < qMin(topNbr + botNbr, _tilesNumber); ++j)
        for (int i = 0; i < qMin(leftNbr + rightNbr, _tilesNumber); ++i)
            if (offsetX + i < _tilesNumber && offsetY + j < _tilesNumber)
                _missing.append(QPoint(offsetX + i, offsetY + j));

    WhirlLessThan cmp;
    cmp.center = center;
    qSort(_missing.begin(), _missing.end(), cmp);
}

void MapWidgetPrivate::removeMissingTile(const QPoint &pos)
{
    _missing.removeOne(pos);
}

QPointF MapWidgetPrivate::posFromCoords(const QPointF &coords) const
{
    // x = longitude
    // y = latitude

    QPointF pos;
    pos.setX((coords.x() + 180.0) * _tilesNumber / 360.0);
    pos.setY((1.0 - log(tan(coords.y() * M_PI / 180.0) + 1.0 / cos(coords.y() * M_PI / 180.0)) / M_PI) / 2.0 * _tilesNumber);

    return pos;
}

QPointF MapWidgetPrivate::coordsFromPos(const QPoint &pos) const
{
    // x = longitude
    // y = latitude

    qreal n = M_PI - 2.0 * M_PI * pos.y() / _tilesNumber;

    QPointF coords;
    coords.setX(pos.x() * 360.0 / _tilesNumber - 180);
    coords.setY(180.0 * atan(0.5 * (exp(n) - exp(-n))) / M_PI);

    return coords;
}

QPoint MapWidgetPrivate::pixelsFromCoords(const QPointF &coords) const
{
    // x = longitude
    // y = latitude

    QPoint pixels;

    pixels.setX((int)((coords.x() + 180.0) * (_tilesNumber * 256) / 360.0));
    pixels.setY((int)((1.0 - (log(tan(M_PI / 4.0 + coords.y() * M_PI / 180.0 / 2.0)) / M_PI)) / 2.0 * _tilesNumber * 256));

    return pixels;
}

QPointF MapWidgetPrivate::coordsFromPixels(const QPoint &pos) const
{
    // x = longitude
    // y = latitude

    QPointF coords;

    coords.setX(pos.x() * 360.0 / (_tilesNumber * 256.0) - 180.0);
    coords.setY((atan(sinh((1.0 - pos.y() * 2.0 / (_tilesNumber * 256.0)) * M_PI))) * 180.0 / M_PI);

    return coords;
}

QSizeF MapWidgetPrivate::tileSize(const QPoint &pos) const
{
    // x = longitude
    // y = latitude

    QPointF current = coordsFromPos(pos);
    QPointF next = coordsFromPos(QPoint(pos.x() + 1, pos.y() + 1));

    QSizeF size;
    size.setWidth(qAbs(current.x() - next.x()));
    size.setHeight(qAbs(current.y() - next.y()));

    return size;
}

void MapWidgetPrivate::displayItinerary(int id)
{
    Q_Q(MapWidget);

    qDeleteAll(_extensions);
    _extensions.clear();

    MapOverlayExtension *ext = new MapOverlayExtension(q);
    ext->setItinerary(id);
    q->addExtension(ext);
}

void MapWidgetPrivate::itineraryChanged()
{
    for (QList<MapExtension *>::const_iterator it = _extensions.constBegin();
         it != _extensions.constEnd(); ++it)
    {
        MapOverlayExtension *ext = qobject_cast<MapOverlayExtension *>(*it);
        if (ext)
            ext->refreshItinerary();
    }
}

const QList<MapExtension *> &MapWidgetPrivate::getExtension() const
{
    return _extensions;
}

void MapWidgetPrivate::addExtension(MapExtension *ext)
{
    if (!_extensions.contains(ext))
        _extensions.append(ext);
}

void MapWidgetPrivate::removeExtension(MapExtension *ext)
{
    _extensions.removeAll(ext);
}

MapGetter *MapWidgetPrivate::getMapGetter() const
{
    return _mapGetter;
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
    Q_D(MapWidget);
    d->initialize();
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

const QList<MapExtension *> &MapWidget::getExtensions() const
{
    Q_D(const MapWidget);
    return d->getExtension();
}

void MapWidget::addExtension(MapExtension *ext)
{
    Q_D(MapWidget);
    d->addExtension(ext);
}

void MapWidget::removeExtension(MapExtension *ext)
{
    Q_D(MapWidget);
    d->removeExtension(ext);
}

void MapWidget::repaint()
{
    Q_D(MapWidget);
    d->displayChanged();
}

void MapWidget::displayItinerary(int id)
{
    Q_D(MapWidget);
    d->displayItinerary(id);
}

void MapWidget::itineraryChanged()
{
    Q_D(MapWidget);
    d->itineraryChanged();
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
    Q_D(MapWidget);
    d->wheelEvent(event);
}

void MapWidget::mousePressEvent(QMouseEvent *event)
{
    Q_D(MapWidget);
    d->mousePressEvent(event);
}

void MapWidget::mouseReleaseEvent(QMouseEvent *event)
{
    Q_D(MapWidget);
    d->mouseReleaseEvent(event);
}

void MapWidget::mouseMoveEvent(QMouseEvent *event)
{
    Q_D(MapWidget);
    d->mouseMoveEvent(event);
}

void MapWidget::touchEvent(QTouchEvent *event)
{
    Q_D(MapWidget);
    d->touchEvent(event);
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
