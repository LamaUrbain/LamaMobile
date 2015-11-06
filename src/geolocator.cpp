#include <QDebug>
#include "geolocator.h"

GeoLocator::GeoLocator()
    : QObject(),
      _provider("osm"),
      _manager(NULL)
{
    if (_provider.error() == QGeoServiceProvider::NoError)
    {
        _manager = _provider.geocodingManager();

        if (_manager)
        {
            connect(_manager, SIGNAL(finished(QGeoCodeReply *)), this, SLOT(onGeocodeFinished(QGeoCodeReply *)));
            connect(_manager, SIGNAL(error(QGeoCodeReply*, QGeoCodeReply::Error, QString)), this, SLOT(onGeocodeFinished(QGeoCodeReply *)));
        }
        else
            qWarning() << "Could not acquire geocoding manager:" << _provider.errorString();
    }
    else
        qWarning() << "Could not acquire geocoding provider:" << _provider.errorString();
}

GeoLocator::~GeoLocator()
{
}

void GeoLocator::geocode(QString address)
{
    if (!_manager)
    {
        emit geocodeFinished(QJsonArray());
        return;
    }
    _manager->geocode(address, 3);
}

void GeoLocator::reverse(double latitude, double longitude)
{
    if (!_manager)
    {
        emit geocodeFinished(QJsonArray());
        return;
    }
    _manager->reverseGeocode(QGeoCoordinate(latitude, longitude));
}

void GeoLocator::onGeocodeFinished(QGeoCodeReply *reply)
{
    QJsonArray results;

    if (reply->error() == QGeoCodeReply::NoError)
    {
        const QList<QGeoLocation> &locations = reply->locations();
        for (QList<QGeoLocation>::const_iterator it = locations.constBegin(); it != locations.constEnd(); ++it)
        {
            const QGeoLocation &location = *it;
            const QGeoCoordinate &coordinate = location.coordinate();

            if (!location.address().isEmpty() && coordinate.isValid())
            {
                QJsonObject obj;
                obj.insert("address", location.address().text());
                obj.insert("street", location.address().street());
                obj.insert("postalCode", location.address().postalCode());
                obj.insert("city", location.address().city());
                obj.insert("latitude", coordinate.latitude());
                obj.insert("longitude", coordinate.longitude());
                results.append(obj);
            }
        }
    }
    else
        qWarning() << reply->error();

    reply->deleteLater();
    emit geocodeFinished(results);
}
