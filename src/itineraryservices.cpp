#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrlQuery>
#include "itineraryservices.h"
#include "userservices.h"

ItineraryServices *ItineraryServices::_instance = NULL;

ItineraryServices::ItineraryServices()
{
    _instance = this;
}

ItineraryServices::~ItineraryServices()
{
}

ItineraryServices *ItineraryServices::getInstance()
{
    return _instance;
}

void ItineraryServices::getItineraries(QString search, QString username, QString favorite, QString ordering, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/").arg(serverAddress));

    QUrlQuery query;
    if (!search.isEmpty())
        query.addQueryItem("search", search);
    if (!username.isEmpty())
        query.addQueryItem("owner", username);
    if (favorite == "true" || favorite == "false")
        query.addQueryItem("favorite", favorite);
    if (ordering == "name" || ordering == "creation")
        query.addQueryItem("ordering", ordering);
    url.setQuery(query.query());

    getRequest(url, callback);
}

void ItineraryServices::getItineraries(QString search, QString username, QString favorite, QString ordering, QJSValue callback)
{
    getItineraries(search, username, favorite, ordering, fromJSCallback(callback));
}

void ItineraryServices::getItinerary(int id, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2").arg(serverAddress).arg(id));
    qDebug() << "getItinerary:" << url.toString();
    getRequest(url, callback);
}

void ItineraryServices::getItinerary(int id, QJSValue callback)
{
    getItinerary(id, fromJSCallback(callback));
}

void ItineraryServices::createItinerary(QString name, QString departure, QString departure_address, QString destination, QString destination_address, QString vehicle, QString favorite, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/").arg(serverAddress));

    QUrlQuery query;
    if (!name.isEmpty())
        query.addQueryItem("name", name);
    query.addQueryItem("departure", departure);
    if (!departure_address.isEmpty())
        query.addQueryItem("departure_address", departure_address);
    if (!destination.isEmpty())
        query.addQueryItem("destination", destination);
    if (!destination_address.isEmpty())
        query.addQueryItem("destination_address", destination_address);
    if (!favorite.isEmpty())
        query.addQueryItem("favorite", !UserServices::getToken().isEmpty() && favorite == "true" ? "true" : "false");
    if (!vehicle.isEmpty())
    {
        if (vehicle == "foot") vehicle = "0";
        else if (vehicle == "bicycle") vehicle = "1";
        else vehicle = "2";
        query.addQueryItem("vehicle", vehicle);
    }
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());

    postRequest(url, query.query().toUtf8(), callback);
}

void ItineraryServices::createItinerary(QString name, QString departure, QString departure_address, QString destination, QString destination_address, QString vehicle, QString favorite, QJSValue callback)
{
    createItinerary(name, departure, departure_address, destination, destination_address, vehicle, favorite, fromJSCallback(callback));
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, QString departure_address, QString vehicle, QString favorite, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2").arg(serverAddress).arg(id));

    QUrlQuery query;
    if (!name.isEmpty())
        query.addQueryItem("name", name);
    if (!departure.isEmpty())
        query.addQueryItem("departure", departure);
    if (!departure_address.isEmpty())
        query.addQueryItem("departure_address", departure_address);
    if (favorite == "true" || favorite == "false")
        query.addQueryItem("favorite", favorite);
    if (!vehicle.isEmpty())
    {
        if (vehicle == "foot") vehicle = "0";
        else if (vehicle == "bicycle") vehicle = "1";
        else vehicle = "2";
        query.addQueryItem("vehicle", vehicle);
    }
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());
    url.setQuery(query.query());

    putRequest(url, QByteArray(), callback);
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, QString departure_address, QString vehicle, QString favorite, QJSValue callback)
{
    editItinerary(id, name, departure, departure_address, vehicle, favorite, fromJSCallback(callback));
}

void ItineraryServices::addDestination(int id, QString destination, QString destination_address, int position, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations").arg(serverAddress).arg(id));

    QUrlQuery query;
    query.addQueryItem("destination", destination);
    if (!destination_address.isEmpty())
        query.addQueryItem("destination_address", destination_address);
    if (position >= 0)
        query.addQueryItem("position", QString::number(position));
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());

    postRequest(url, query.query().toUtf8(), callback);
}

void ItineraryServices::addDestination(int id, QString destination, QString destination_address, int position, QJSValue callback)
{
    addDestination(id, destination, destination_address, position, fromJSCallback(callback));
}

void ItineraryServices::editDestination(int id, int oldPosition, int newPosition, QString destination, QString destination_address, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations/%3").arg(serverAddress).arg(id).arg(oldPosition));

    QUrlQuery query;
    if (!destination.isEmpty())
        query.addQueryItem("destination", destination);
    if (!destination_address.isEmpty())
        query.addQueryItem("destination_address", destination_address);
    if (newPosition >= 0)
        query.addQueryItem("position", QString::number(newPosition));
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());
    url.setQuery(query.query());

    putRequest(url, QByteArray(), callback);
}

void ItineraryServices::editDestination(int id, int oldPosition, int newPosition, QString destination, QString destination_address, QJSValue callback)
{
    editDestination(id, oldPosition, newPosition, destination, destination_address, fromJSCallback(callback));
}

void ItineraryServices::deleteDestination(int id, int position, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations/%3").arg(serverAddress).arg(id).arg(position));

    if (!UserServices::getToken().isEmpty())
    {
        QUrlQuery query;
        query.addQueryItem("token", UserServices::getToken());
        url.setQuery(query.query());
    }

    deleteRequest(url, callback);
}

void ItineraryServices::deleteDestination(int id, int position, QJSValue callback)
{
    deleteDestination(id, position, fromJSCallback(callback));
}

void ItineraryServices::deleteItinerary(int id, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2").arg(serverAddress).arg(id));

    if (!UserServices::getToken().isEmpty())
    {
        QUrlQuery query;
        query.addQueryItem("token", UserServices::getToken());
        url.setQuery(query.query());
    }

    deleteRequest(url, callback);
}

void ItineraryServices::deleteItinerary(int id, QJSValue callback)
{
    deleteItinerary(id, fromJSCallback(callback));
}

void ItineraryServices::getItineraryTiles(int id, int zoomLevel, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/coordinates/%3").arg(serverAddress).arg(id).arg(zoomLevel));
    qDebug() << "getItineraryTiles:" << url.toString();
    getRequest(url, callback);
}

void ItineraryServices::getItineraryTiles(int id, int zoomLevel, QJSValue callback)
{
    getItineraryTiles(id, zoomLevel, fromJSCallback(callback));
}
