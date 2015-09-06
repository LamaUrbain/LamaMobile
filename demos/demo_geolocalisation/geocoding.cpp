#include <QDebug>
#include "geocoding.h"

geoCoding::geoCoding(QObject *parent)
    : QObject(parent),
      _provider("osm"),
      _manager(NULL)
{
    if (_provider.error() == QGeoServiceProvider::NoError)
    {
        _manager = _provider.geocodingManager();
        if (_manager)
        {
            connect(_manager, SIGNAL (finished(QGeoCodeReply *)), this, SLOT (getAddrFromCoordFinished(QGeoCodeReply *)));
            connect(_manager, SIGNAL (error (QGeoCodeReply*, QGeoCodeReply::Error, QString)), this, SLOT (getAddrFromCoordFinished(QGeoCodeReply *)));
        }
        else
            qWarning() << "Could not acquire geocoding manager:" << _provider.errorString();
    }
    else
        qWarning() << "Could not acquire geocoding provider:" << _provider.errorString();
}

geoCoding::~geoCoding()
{
}

bool geoCoding::getAddrFromCoord(double latitude, double longitude)
{
    QGeoCoordinate geoCoord(latitude, longitude);

    if (_manager)
    {
        _manager->reverseGeocode(geoCoord);

        return true;
    }
    return false;
}

void geoCoding::getAddrFromCoordFinished(QGeoCodeReply *reply)
{
    QStringList retList;

    if (reply->error() == QGeoCodeReply::NoError)
    {
        foreach (QGeoLocation location, reply->locations())
            retList.append(location.address().text());
    }
    else
        qWarning() << reply->error();

    qWarning() << retList.count() << " = Count List Ret";
    reply->deleteLater();
    emit addrFromCoordReceived(retList);
}
