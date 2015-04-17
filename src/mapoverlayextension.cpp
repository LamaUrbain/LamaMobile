#include <cmath>
#include <QPixmap>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonParseError>
#include <QJsonObject>
#include "mapoverlayextension.h"
#include "itineraryservices.h"
#include "mapgetter.h"

static const int indicatorHalfWidth = 24;
static const int indicatorHeight = 48;

MapOverlayExtension::MapOverlayExtension(MapWidget *map)
    : MapExtension(map),
      _indicator(":/images/map_indicator.png"),
      _selectedIndicator(":/images/map_indicator_selected.png"),
      _selectedPoint(-1),
      _itineraryId(-1)
{
    for (int i = 0; i < 20; ++i)
        _itineraryTiles[i] = NULL;

    getMapPrivate()->getMapGetter()->addExtension(this);
}

MapOverlayExtension::~MapOverlayExtension()
{
    getMapPrivate()->getMapGetter()->removeExtension(this);
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
    int current = 0;

    for (QList<QPointF>::const_iterator it = _points.constBegin(); it != _points.constEnd(); ++it)
    {
        const QPointF &coords = *it;
        QPointF pos = getMapPrivate()->posFromCoords(coords);
        _tilePoints[scale].insert(QPoint((int)pos.x(), (int)pos.y()), PairPointF(pos, current));
        ++current;
    }
}

int MapOverlayExtension::pointAt(const QPoint &pos) const
{
    const QPoint &offset = getMapPrivate()->getScrollOffset();

    for (QList<PairPoint>::const_iterator it = _pending.constBegin(); it != _pending.constEnd(); ++it)
    {
        const QPoint &pending = (*it).first;

        QRect bounds(pending.x() + offset.x(), pending.y() + offset.y(), indicatorHalfWidth * 2, indicatorHeight);

        if (bounds.contains(pos))
            return (*it).second;
    }

    return -1;
}

int MapOverlayExtension::getItinerary() const
{
    return _itineraryId;
}

void MapOverlayExtension::setItinerary(int id)
{
    _itineraryId = id;
    connect(_map, SIGNAL(mapScaleChanged()), this, SLOT(updateTiles()));
    updateTiles();
}

void MapOverlayExtension::updateTiles()
{
    int currentScale = _map->getMapScale();

    if (_itineraryTiles[currentScale] == NULL)
    {
        ItineraryServices *services = ItineraryServices::getInstance();
        services->getItinerary(_itineraryId, currentScale, [this, currentScale] (int errorType, QString jsonStr) mutable
        {
            if (errorType == 0)
            {
                _itineraryTiles[currentScale] = new QList<QPoint>();

                QJsonParseError error;
                QJsonDocument document = QJsonDocument::fromJson(jsonStr.toLatin1(), &error);

                if (error.error != QJsonParseError::NoError)
                    qDebug() << jsonStr << ":" << error.errorString() << "at pos" << error.offset;
                else if (!document.isArray())
                    qDebug() << jsonStr << ": not an array";
                else
                {
                    QJsonArray array = document.array();
                    for (QJsonArray::const_iterator it = array.constBegin(); it != array.constEnd(); ++it)
                    {
                        QJsonObject obj = (*it).toObject();

                        if (obj.contains("x") && obj.contains("y"))
                        {
                            int x = obj.value("x").toInt();
                            int y = obj.value("y").toInt();

                            qDebug() << "Receive:" << x << y;

                            _itineraryTiles[currentScale]->append(QPoint(x, y));
                        }
                    }

                    _map->repaint();
                }
            }
        });
    }
}

const QList<QPoint> &MapOverlayExtension::getMissingTiles(int scale) const
{
    return _missing[scale];
}

void MapOverlayExtension::begin(QPainter *painter)
{
    Q_UNUSED(painter);

    _pending.clear();

    for (int i = 0; i < 20; ++i)
        _missing[i].clear();
}

void MapOverlayExtension::drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos)
{
    quint8 scale = _map->getMapScale();

    if (_tilePoints[scale].size() != _points.size())
        generateTilePoints(scale);

    QHash<QPoint, MapTile>::const_iterator it = _tiles[scale].constFind(pos);
    QMultiHash<QPoint, PairPointF>::const_iterator pit = _tilePoints[scale].constFind(pos);

    if (it != _tiles[scale].end())
    {
        const MapTile &tile = it.value();
        painter->drawPixmap(tilePos, tile.pixmap);
    }
    else if (_itineraryTiles[scale] && _itineraryTiles[scale]->contains(pos))
        _missing[scale].push_back(pos);

    while (pit != _tilePoints[scale].constEnd() && pit.key() == pos)
    {
        const QPointF &pos = (*pit).first;

        int xOffset = qBound<qreal>(0, pos.x() - (qreal)((int)pos.x()), 1) * 256.0 - indicatorHalfWidth;
        int yOffset = qBound<qreal>(0, pos.y() - (qreal)((int)pos.y()), 1) * 256.0 - indicatorHeight;

        _pending.append(PairPoint(QPoint(tilePos.x() + xOffset, tilePos.y() + yOffset), (*pit).second));

        ++pit;
    }
}

void MapOverlayExtension::end(QPainter *painter)
{
    for (QList<PairPoint>::const_iterator it = _pending.constBegin(); it != _pending.constEnd(); ++it)
    {
        const QPoint &pos = (*it).first;
        painter->drawPixmap(pos, (*it).second == _selectedPoint ? _selectedIndicator : _indicator);
    }

    quint8 scale = _map->getMapScale();

    if (!_missing[scale].isEmpty())
        emit tilesRequired();
}

bool MapOverlayExtension::mousePressEvent(QMouseEvent *event)
{
    if (_selectedPoint != -1)
    {
        if (_selectedPoint < _points.size())
        {
            QPoint pos;
            MapWidgetPrivate *p = getMapPrivate();

            pos.setX(p->getCenterPos().x() * 256 + p->getCenterOffset().x() - p->getScrollOffset().x() - 256 + event->pos().x() - _map->width() / 2);
            pos.setY(p->getCenterPos().y() * 256 + p->getCenterOffset().y() - p->getScrollOffset().y() - 256 + event->pos().y() - _map->height() / 2);

            QPointF newCoords = p->coordsFromPixels(pos);

            movePoint(_selectedPoint, newCoords);
            emit pointMoved(_selectedPoint, newCoords);
        }

        _selectedPoint = -1;
        return true;
    }

    int point = pointAt(event->pos());

    if (point != -1)
    {
        _selectedPoint = point;
        _map->repaint();
        return true;
    }

    _selectedPoint = -1;
    return false;
}

bool MapOverlayExtension::mouseReleaseEvent(QMouseEvent *event)
{
    Q_UNUSED(event);

    if (_selectedPoint != -1)
        return true;

    return false;
}

bool MapOverlayExtension::mouseMoveEvent(QMouseEvent *event)
{
    Q_UNUSED(event);

    if (_selectedPoint != -1)
        return true;

    return false;
}
