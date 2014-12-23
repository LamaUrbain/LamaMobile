#include <QNetworkReply>
#include "mapgetter.h"
#include "mapwidget.h"

// This number is the maximum number of parallel
// requests defined in QNetworkAccessManager
static quint8 MaxPendingRequests = 3;
static quint8 MaxNetworkGetters = 4;

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

void MapGetter::setWidget(MapWidget *widget)
{
    if (widget && _widget != widget)
    {
        _widget = widget;
        connect(_widget, SIGNAL(mapTileRequired()), this, SLOT(onTilesRequired()), Qt::QueuedConnection);
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

        const QPoint &pos = *it;

        if (_pending.contains(pos))
            continue;

        Getter *getter = getNextGetter();
        if (!getter)
            return;

        QString address = "http://tile.openstreetmap.org/%1/%2/%3.png";
        QUrl url(address.arg(_widget->getMapScale()).arg(pos.x()).arg(pos.y()));

        QNetworkRequest request(url);
        request.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");

        _pending.append(pos);
        getter->_pending.append(pos);
        getter->_manager.get(request);

        qDebug() << "Send:" << pos << url.toString();
    }
}

void MapGetter::onRequestFinished(QNetworkReply *reply)
{
    if (reply)
    {
        Getter *getter = getManagerGetter(reply->manager());

        if (!getter)
            return;

        QRegExp rx("/([0-9]+)/([0-9]+)/([0-9]+).png");
        rx.indexIn(reply->url().toString());
        QStringList list = rx.capturedTexts();

        qDebug() << "Receive:" << reply->url().toString() << list;

        if (list.size() == 4)
        {
            MapTile tile;
            tile.scale = list.at(1).toInt();
            tile.pos = QPoint(list.at(2).toInt(), list.at(3).toInt());

            if (reply->error() == QNetworkReply::NoError
                && tile.pixmap.loadFromData(reply->readAll()))
            {
                qDebug() << "Tile:" << tile.scale << tile.pos;
                _widget->addTile(tile);
            }

            _pending.removeAll(tile.pos);
            getter->_pending.removeAll(tile.pos);
            onTilesRequired();
        }
    }
}
