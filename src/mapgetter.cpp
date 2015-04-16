#include <QNetworkReply>
#include "mapgetter.h"
#include "mapwidget.h"
#include "mapoverlayextension.h"

// This number is the maximum number of parallel
// requests defined in QNetworkAccessManager
static quint8 MaxPendingRequests = 3;
static quint8 MaxNetworkGetters = 4;

MapGetter::Tile::Tile()
    : scale(0), reply(0), extension(0)
{
}

MapGetter::Tile::Tile(const QPoint &p, quint8 s, MapOverlayExtension *ext)
    : pos(p), scale(s), reply(0), extension(ext)
{
}

MapGetter::Tile::Tile(const Tile &other)
    : pos(other.pos), scale(other.scale), reply(other.reply), extension(other.extension)
{
}

MapGetter::Tile &MapGetter::Tile::operator=(const Tile &other)
{
    pos = other.pos;
    scale = other.scale;
    reply = other.reply;
    extension = other.extension;
    return *this;
}

bool MapGetter::Tile::operator==(const Tile &other)
{
    return scale == other.scale && pos == other.pos && extension == other.extension;
}

MapGetter::MapGetter(QObject *parent)
    : QObject(parent),
      _widget(NULL)
{
    for (quint8 i = 0; i < MaxNetworkGetters; ++i)
    {
        Getter *getter = new Getter;
        connect(&getter->_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onRequestFinished(QNetworkReply*)));
        _getters.append(getter);
    }
}

MapGetter::~MapGetter()
{
}

const QList<MapOverlayExtension *> &MapGetter::getExtensions() const
{
    return _extensions;
}

void MapGetter::addExtension(MapOverlayExtension *ext)
{
    if (!_extensions.contains(ext))
    {
        _extensions.append(ext);
        connect(ext, SIGNAL(tilesRequired()), this, SLOT(onTilesRequired()));
    }
}

void MapGetter::removeExtension(MapOverlayExtension *ext)
{
    disconnect(ext, SIGNAL(tilesRequired()), this, SLOT(onTilesRequired()));
    _extensions.removeAll(ext);
    cancelRequests();
    onTilesRequired();
}

void MapGetter::setWidget(MapWidget *widget)
{
    if (widget && _widget != widget)
    {
        _widget = widget;
        connect(_widget, SIGNAL(mapTileRequired()), this, SLOT(onTilesRequired()), Qt::QueuedConnection);
        connect(_widget, SIGNAL(mapScaleChanged()), this, SLOT(cancelRequests()), Qt::QueuedConnection);
        onTilesRequired();
    }
}

MapGetter::Getter *MapGetter::getNextGetter() const
{
    Getter *next = NULL;

    for (QList<Getter *>::const_iterator it = _getters.constBegin(); it != _getters.constEnd(); ++it)
    {
        Getter *getter = *it;
        if (getter && getter->_pending.size() < MaxPendingRequests
            && (!next || getter->_pending.size() < next->_pending.size()))
        {
            next = getter;
        }
    }

    return next;
}

MapGetter::Getter *MapGetter::getManagerGetter(QNetworkAccessManager *manager) const
{
    for (QList<Getter *>::const_iterator it = _getters.constBegin(); it != _getters.constEnd(); ++it)
    {
        Getter *getter = *it;
        if (getter && manager == &getter->_manager)
            return getter;
    }

    return NULL;
}

void MapGetter::onTilesRequired()
{
    if (_pending.size() >= MaxPendingRequests * MaxNetworkGetters)
        return;

    const QList<QPoint> &missing = _widget->getMissingTiles();

    for (QList<QPoint>::const_iterator it = missing.constBegin(); it != missing.constEnd(); ++it)
    {
        if (_pending.size() >= MaxPendingRequests * MaxNetworkGetters)
            return;

        Tile tile(*it, _widget->getMapScale());

        if (_pending.contains(tile))
            continue;

        Getter *getter = getNextGetter();
        if (!getter)
            return;

        QString address = "http://tile.openstreetmap.org/%1/%2/%3.png";
        QUrl url(address.arg(tile.scale).arg(tile.pos.x()).arg(tile.pos.y()));

        QNetworkRequest request(url);
        request.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
        QNetworkReply *reply = getter->_manager.get(request);

        if (reply)
        {
            tile.reply = reply;
            _replies.append(reply);
            _pending.append(tile);
            getter->_pending.append(tile);
        }
    }

    foreach (MapOverlayExtension *ext, _extensions)
    {
        const QList<QPoint> &missing = ext->getMissingTiles(_widget->getMapScale());

        for (QList<QPoint>::const_iterator it = missing.constBegin(); it != missing.constEnd(); ++it)
        {
            if (_pending.size() >= MaxPendingRequests * MaxNetworkGetters)
                return;

            Tile tile(*it, _widget->getMapScale(), ext);

            if (_pending.contains(tile))
                continue;

            Getter *getter = getNextGetter();
            if (!getter)
                return;

            QString address = "TODO/itineraries/%1/tiles/%2/%3/%4";
            QUrl url(address.arg(ext->getItinerary()).arg(tile.scale).arg(tile.pos.x()).arg(tile.pos.y()));

            QNetworkRequest request(url);
            request.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
            QNetworkReply *reply = getter->_manager.get(request);

            if (reply)
            {
                tile.reply = reply;
                _replies.append(reply);
                _pending.append(tile);
                getter->_pending.append(tile);
            }
        }
    }
}

void MapGetter::onRequestFinished(QNetworkReply *reply)
{
    if (reply)
    {
        Getter *getter = getManagerGetter(reply->manager());

        if (!getter)
            return;

        for (QList<Tile>::const_iterator it = _pending.constBegin(); it != _pending.constEnd(); ++it)
        {
            Tile info = *it;

            if (info.reply == reply)
            {
                MapTile tile;
                tile.scale = info.scale;
                tile.pos = info.pos;

                if (reply->error() == QNetworkReply::NoError
                    && tile.pixmap.loadFromData(reply->readAll()))
                {
                    if (!info.extension)
                        _widget->addTile(tile);
                    else
                        info.extension->addTile(tile);
                    _errors.removeAll(info);
                }
                else if (reply->error() != QNetworkReply::OperationCanceledError)
                {
                    if (_errors.contains(info))
                    {
                        qDebug() << "Error:" << tile.scale << tile.pos << reply->errorString();
                        tile.pixmap = QPixmap(1, 1);
                        if (!info.extension)
                            _widget->addTile(tile);
                        else
                            info.extension->addTile(tile);
                        _errors.removeAll(info);
                    }
                    else
                        _errors.append(info);
                }

                _pending.removeAll(info);
                getter->_pending.removeAll(info);
                onTilesRequired();

                _replies.removeAll(reply);
                reply->deleteLater();

                return;
            }
        }
    }
}

void MapGetter::cancelRequests()
{
    foreach (Tile tile, _errors)
        _widget->removeTile(MapTile(tile.scale, tile.pos, QPixmap()));

    _errors.clear();
    _pending.clear();

    for (QList<Getter *>::const_iterator it = _getters.constBegin(); it != _getters.constEnd(); ++it)
    {
        Getter *getter = *it;
        if (getter)
            getter->_pending.clear();
    }

    foreach (QNetworkReply *reply, _replies)
    {
        if (reply)
        {
            reply->abort();
            _replies.removeAll(reply);
            reply->deleteLater();
        }
    }
}
