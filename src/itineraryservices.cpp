#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrlQuery>
#include "itineraryservices.h"

static QString serverAddress = "TODO";

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

void ItineraryServices::getItineraries(QString search, QString username, bool favorite, QString ordering, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/").arg(serverAddress));

    QUrlQuery query;
    query.addQueryItem("search", search);
    query.addQueryItem("owner", username);
    query.addQueryItem("favorite", favorite ? "True" : "False");
    query.addQueryItem("ordering", ordering);
    url.setQuery(query.query());

    getRequest(url, callback);
}

void ItineraryServices::getItineraries(QString search, QString username, bool favorite, QString ordering, QJSValue callback)
{
    getItineraries(search, username, favorite, ordering, fromJSCallback(callback));
}

void ItineraryServices::getItinerary(int id, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/").arg(serverAddress).arg(id));
    getRequest(url, callback);
}

void ItineraryServices::getItinerary(int id, QJSValue callback)
{
    getItinerary(id, fromJSCallback(callback));
}

void ItineraryServices::createItinerary(QString name, QString departure, QString destination, bool favorite, ServicesBase::CallbackType callback)
{
    // TODO: check if it should be encoded as JSON or as HTTP parameters

    QJsonObject obj;
    obj.insert("name", QJsonValue(name));
    obj.insert("departure", QJsonValue(departure));
    obj.insert("destination", QJsonValue(destination));
    obj.insert("favorite", QJsonValue(favorite));
    QJsonDocument document(obj);

    QUrl url(QString("%1/itineraries/").arg(serverAddress));
    postRequest(url, document.toJson(QJsonDocument::Compact), callback);
}

void ItineraryServices::createItinerary(QString name, QString departure, QString destination, bool favorite, QJSValue callback)
{
    createItinerary(name, departure, destination, favorite, fromJSCallback(callback));
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, bool favorite, ServicesBase::CallbackType callback)
{
    // TODO: check if it should be encoded as JSON or as HTTP parameters

    QJsonObject obj;
    obj.insert("name", QJsonValue(name));
    obj.insert("departure", QJsonValue(departure));
    obj.insert("favorite", QJsonValue(favorite));
    QJsonDocument document(obj);

    QUrl url(QString("%1/itineraries/%2/").arg(serverAddress).arg(id));
    putRequest(url, document.toJson(QJsonDocument::Compact), callback);
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, bool favorite, QJSValue callback)
{
    editItinerary(id, name, departure, favorite, fromJSCallback(callback));
}

void ItineraryServices::addDestination(int id, QString destination, int position, ServicesBase::CallbackType callback)
{
    // TODO: check if it should be encoded as JSON or as HTTP parameters
    // TODO: authentication

    QJsonObject obj;
    obj.insert("destination", QJsonValue(destination));
    obj.insert("position", QJsonValue(position));
    QJsonDocument document(obj);

    QUrl url(QString("%1/itineraries/%2/destinations/").arg(serverAddress).arg(id));
    postRequest(url, document.toJson(QJsonDocument::Compact), callback);
}

void ItineraryServices::addDestination(int id, QString destination, int position, QJSValue callback)
{
    addDestination(id, destination, position, fromJSCallback(callback));
}

void ItineraryServices::editDestination(int id, int position, QString destination, ServicesBase::CallbackType callback)
{
    // TODO: check if it should be encoded as JSON or as HTTP parameters

    QJsonObject obj;
    obj.insert("destination", QJsonValue(destination));
    obj.insert("position", QJsonValue(position));
    QJsonDocument document(obj);

    QUrl url(QString("%1/itineraries/%2/destinations/%3/").arg(serverAddress).arg(id).arg(position));
    putRequest(url, document.toJson(QJsonDocument::Compact), callback);
}

void ItineraryServices::editDestination(int id, int position, QString destination, QJSValue callback)
{
    editDestination(id, position, destination, fromJSCallback(callback));
}

void ItineraryServices::deleteDestination(int id, int position, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations/%3/").arg(serverAddress).arg(id).arg(position));
    deleteRequest(url, callback);
}

void ItineraryServices::deleteDestination(int id, int position, QJSValue callback)
{
    deleteDestination(id, position, fromJSCallback(callback));
}

void ItineraryServices::deleteItinerary(int id, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/").arg(serverAddress).arg(id));
    deleteRequest(url, callback);
}

void ItineraryServices::deleteItinerary(int id, QJSValue callback)
{
    deleteItinerary(id, fromJSCallback(callback));
}

void ItineraryServices::getItineraryTiles(int id, int zoomLevel, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/coordinates/%3").arg(serverAddress).arg(id).arg(zoomLevel));
    getRequest(url, callback);
}

void ItineraryServices::getItineraryTiles(int id, int zoomLevel, QJSValue callback)
{
    getItineraryTiles(id, zoomLevel, fromJSCallback(callback));
}
