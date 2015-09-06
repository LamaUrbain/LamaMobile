#ifndef GEOCODING_H
#define GEOCODING_H

#include <QObject>
#include <QtQml>
#include <QGeoCodingManager>
#include <QGeoCoordinate>
#include <QString>
#include <QGeoAddress>
#include <QGeoServiceProvider>

class geoCoding : public QObject
{
    Q_OBJECT
public:
    explicit geoCoding(QObject *parent = 0);
    ~geoCoding();

signals:
    void addrFromCoordReceived(QStringList addrList);

public slots:
    // Request Addr corresponding to the latitude and longitude specified
    bool getAddrFromCoord(double latitude, double longitude);

private slots:
    // Fonction called when the request is finished
    void getAddrFromCoordFinished(QGeoCodeReply *reply);

private:
    QGeoServiceProvider _provider;
    QGeoCodingManager *_manager;
};

#endif // GEOCODING_H
