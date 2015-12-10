#include <QDebug>
#include "geolocator.h"

GeoLocator::GeoLocator()
    : QObject(),
      _provider("osm"),
      _manager(NULL)
{
    if (_provider.error() == QGeoServiceProvider::NoError)
    {
        _positioner = QGeoPositionInfoSource::createDefaultSource(this);
        if (_positioner)
        {
            connect(_positioner, SIGNAL(positionUpdated(QGeoPositionInfo)),
                    this, SLOT(positionUpdated(QGeoPositionInfo)));
            _positioner->setUpdateInterval(15000);
            _positioner->startUpdates();
        }
        else
            qWarning() << "Could not acquire geocoding positioner";

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

void GeoLocator::_positionUpdated(const QGeoPositionInfo &info)
{
    _currentPosition = info;
}

void GeoLocator::geocode(QString address)
{
    if (!_manager)
    {
        emit geocodeFinished(QJsonArray());
        return;
    }
    _manager->geocode(address, GEOCODE_LIMIT_RESULTS);
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
        const QGeoLocation *location = NULL, *nearestLocation = NULL;
        double currentDistance = std::numeric_limits<double>::max();
        for (QList<QGeoLocation>::const_iterator it = locations.constBegin(); it != locations.constEnd(); ++it)
        {
            location = &(*it);
            const QGeoCoordinate &coordinate = location->coordinate();
            if (_currentPosition.isValid())
            {
                const double distance = _calculateDistance(coordinate);
                if (distance < currentDistance)
                {
                    nearestLocation = location;
                    currentDistance = distance;
                }
            }
            else if (nearestLocation == NULL)
                nearestLocation = location;
        }

        if (nearestLocation && !nearestLocation->address().isEmpty() && nearestLocation->coordinate().isValid())
        {
            QJsonObject obj;
            obj.insert("address", nearestLocation->address().text());
            obj.insert("street", nearestLocation->address().street());
            obj.insert("postalCode", nearestLocation->address().postalCode());
            obj.insert("city", nearestLocation->address().city());
            obj.insert("latitude", nearestLocation->coordinate().latitude());
            obj.insert("longitude", nearestLocation->coordinate().longitude());
            results.append(obj);
        }
    }
    else
        qWarning() << reply->error();

    reply->deleteLater();
    emit geocodeFinished(results);
}

double GeoLocator::_calculateDistance(const QGeoCoordinate &ref)
{
    const double dLat = qDegreesToRadians(ref.latitude() - _currentPosition.coordinate().latitude());
    const double dLon = qDegreesToRadians(ref.longitude() - _currentPosition.coordinate().longitude());
    const double ALat = qDegreesToRadians(_currentPosition.coordinate().latitude());
    const double BLat = qDegreesToRadians(ref.latitude());

    const double angle = qSin(dLat/2) * qSin(dLat/2) +
                qSin(dLon/2) * qSin(dLon/2) * qCos(ALat) * qCos(BLat);
    return (2 * qAtan2(qSqrt(angle), qSqrt(1 - angle)) * 6371);
}
