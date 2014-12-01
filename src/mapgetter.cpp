#include <QNetworkReply>
#include "mapgetter.h"
#include "mapwidget.h"

// This number is the maximum number of parallel
// requests defined in QNetworkAccessManager
static quint8 MaxPendingRequests = 6;

MapGetter::MapGetter(QObject *parent)
    : QObject(parent),
      _widget(NULL)
{
    connect(&_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onRequestFinished(QNetworkReply*)));
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

void MapGetter::onTilesRequired()
{
    if (_pending.size() >= MaxPendingRequests)
        return;

    const QList<QPoint> &missing = _widget->getMissingTiles();

    for (QList<QPoint>::const_iterator it = missing.constBegin(); it != missing.constEnd(); ++it)
    {
        if (_pending.size() >= MaxPendingRequests)
            return;

        const QPoint &pos = *it;

        if (_pending.contains(pos))
            continue;

        QString base = "a";
        int domain = qrand() % 3;

        if (domain == 1)
            base = "b";
        else if (domain == 2)
            base = "c";

        QString address = "http://%1.tile.openstreetmap.fr/osmfr/%2/%3/%4.png";
        QUrl url(address.arg(base).arg(_widget->getMapScale()).arg(pos.x()).arg(pos.y()));

        _pending.append(pos);
        _manager.get(QNetworkRequest(url));

        qDebug() << "Send:" << pos << url.toString();
    }
}

void MapGetter::onRequestFinished(QNetworkReply *reply)
{
    if (reply)
    {
        QRegExp rx("/([0-9]+)/([0-9]+)/([0-9]+).png");
        rx.indexIn(reply->url().toString());
        QStringList list = rx.capturedTexts();

        // TODO: use a struct to avoid the use of a regexp (faster and safer)

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
            onTilesRequired();
        }
    }
}
