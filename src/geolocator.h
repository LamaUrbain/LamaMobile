#ifndef GEOLOCATOR_H
#define GEOLOCATOR_H

#include <QObject>
#include <QtQml>
#include <QGeoCodingManager>
#include <QGeoCoordinate>
#include <QString>
#include <QGeoAddress>
#include <QGeoServiceProvider>
#include <QGeoPositionInfoSource>
QMATH_H

#define GEOCODE_LIMIT_RESULTS (5)

class GeoLocator : public QObject
{
    Q_OBJECT

public:
    GeoLocator();
    virtual ~GeoLocator();

signals:
    void geocodeFinished(QJsonArray results);

public slots:
    void geocode(QString address);
    void reverse(double latitude, double longitude);

private slots:
    void onGeocodeFinished(QGeoCodeReply *reply);

private:
    QGeoServiceProvider _provider;
    QGeoCodingManager *_manager;
    QGeoPositionInfoSource *_positioner;
    QGeoPositionInfo _currentPosition;

    void _positionUpdated(const QGeoPositionInfo &info);
    double _calculateDistance(const QGeoCoordinate &ref);
};

#endif // GEOLOCATOR_H
