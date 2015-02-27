#include <cmath>
#include <QPixmap>
#include "mapoverlayextension.h"

static const int indicatorHalfWidth = 24;
static const int indicatorHeight = 48;

MapOverlayExtension::MapOverlayExtension(MapWidget *map)
    : MapExtension(map),
      _indicator(":/images/map_indicator.png")
{
}

MapOverlayExtension::~MapOverlayExtension()
{
}

void MapOverlayExtension::addTile(const MapTile &tile)
{
    if (!tile.pixmap.isNull() && tile.pixmap.width() > 0 && tile.pixmap.height() > 0)
    {
        _tiles[tile.scale][tile.pos] = tile;
        _map->repaint();
    }
}

void MapOverlayExtension::removeTile(const MapTile &tile)
{
    _tiles[tile.scale].remove(tile.pos);
    _map->repaint();
}

const QList<QPointF> &MapOverlayExtension::getPoints() const
{
    return _points;
}

void MapOverlayExtension::appendPoint(const QPointF &coords)
{
    _points.append(coords);
    onTilesChanged();
}

void MapOverlayExtension::prependPoint(const QPointF &coords)
{
    _points.prepend(coords);
    onTilesChanged();
}

void MapOverlayExtension::insertPoint(int pos, const QPointF &coords)
{
    _points.insert(pos, coords);
    onTilesChanged();
}

void MapOverlayExtension::movePoint(int pos, const QPointF &coords)
{
    _points[pos] = coords;
    onTilesChanged();
}

void MapOverlayExtension::removePoint(int pos)
{
    _points.removeAt(pos);
    onTilesChanged();
}

void MapOverlayExtension::onTilesChanged()
{
    for (quint8 i = 0; i < 20; ++i)
        _tilePoints[i].clear();
    _map->repaint();
}

void MapOverlayExtension::generateTilePoints(quint8 scale)
{
    int tilesNumber = pow(2.0, scale);

    for (QList<QPointF>::const_iterator it = _points.constBegin(); it != _points.constEnd(); ++it)
    {
        const QPointF &coords = *it;

        QPointF pos;
        pos.setX((coords.x() + 180.0) * tilesNumber / 360.0);
        pos.setY((1.0 - log(tan(coords.y() * M_PI / 180.0) + 1.0 / cos(coords.y() * M_PI / 180.0)) / M_PI) / 2.0 * tilesNumber);

        _tilePoints[scale].insert(QPoint((int)pos.x(), (int)pos.y()), pos);
    }
}

void MapOverlayExtension::begin(QPainter *painter)
{
    Q_UNUSED(painter);
    _pending.clear();
}

void MapOverlayExtension::drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos)
{
    quint8 scale = _map->getMapScale();

    if (_tilePoints[scale].size() != _points.size())
        generateTilePoints(scale);

    QHash<QPoint, MapTile>::const_iterator it = _tiles[scale].constFind(pos);
    QMultiHash<QPoint, QPointF>::const_iterator pit = _tilePoints[scale].constFind(pos);

    if (it != _tiles[scale].end())
    {
        const MapTile &tile = it.value();
        painter->drawPixmap(tilePos, tile.pixmap);
    }

    while (pit != _tilePoints[scale].constEnd() && pit.key() == pos)
    {
        const QPointF &pos = *pit;

        int xOffset = qBound<qreal>(0, pos.x() - (int)pos.x(), 1) * 256.0 - indicatorHalfWidth;
        int yOffset = qBound<qreal>(0, pos.y() - (int)pos.y(), 1) * 256.0 - indicatorHeight;

        _pending.append(QPoint(tilePos.x() + xOffset, tilePos.y() + yOffset));

        ++pit;
    }
}

void MapOverlayExtension::end(QPainter *painter)
{
    for (QList<QPoint>::const_iterator it = _pending.constBegin(); it != _pending.constEnd(); ++it)
    {
        const QPoint &pos = *it;
        painter->drawPixmap(pos, _indicator);
    }
    _pending.clear();
}
