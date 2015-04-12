#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include "itineraryservices.h"

static QString serverAddress = "TODO";

ItineraryServices::ItineraryServices()
{
}

ItineraryServices::~ItineraryServices()
{
}

void ItineraryServices::createItinerary(QVariantList points, QJSValue callback)
{
    QJsonObject obj;
    obj.insert("points", QJsonArray::fromVariantList(points));
    QJsonDocument document(obj);

    QUrl url(QString("%1/itineraries/").arg(serverAddress));
    postRequest(url, document.toJson(QJsonDocument::Compact), callback);
}

void ItineraryServices::deleteItinerary(int id, QJSValue callback)
{
    QUrl url(QString("%1/itineraries/%2").arg(serverAddress).arg(id));
    deleteRequest(url, callback);
}

void ItineraryServices::getItinerary(int id, int zoomLevel, QJSValue callback)
{
    QUrl url(QString("%1/itineraries/%2/coordinates/%3").arg(serverAddress).arg(id).arg(zoomLevel));
    getRequest(url, callback);
}
