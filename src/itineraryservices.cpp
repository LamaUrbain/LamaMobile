#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrlQuery>
#include <memory>
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

void ItineraryServices::createItinerary(QString name, QString departure, QString destination, QString favorite, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/").arg(serverAddress));

    QUrlQuery query;
    if (!name.isEmpty())
        query.addQueryItem("name", name);
    query.addQueryItem("departure", departure);
    if (!destination.isEmpty())
        query.addQueryItem("destination", destination);
    query.addQueryItem("favorite", !UserServices::getToken().isEmpty() && favorite == "true" ? "true" : "false");
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());

    postRequest(url, query.query().toLocal8Bit(), callback);
}

void ItineraryServices::createItinerary(QString name, QString departure, QString destination, QString favorite, QJSValue callback)
{
    createItinerary(name, departure, destination, favorite, fromJSCallback(callback));
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, QString favorite, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/").arg(serverAddress).arg(id));

    QUrlQuery query;
    if (!name.isEmpty())
        query.addQueryItem("name", name);
    if (!departure.isEmpty())
        query.addQueryItem("departure", departure);
    if (favorite == "true" || favorite == "false")
        query.addQueryItem("favorite", favorite);
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());
    url.setQuery(query.query());

    putRequest(url, QByteArray(), callback);
}

void ItineraryServices::editItinerary(int id, QString name, QString departure, QString favorite, QJSValue callback)
{
    editItinerary(id, name, departure, favorite, fromJSCallback(callback));
}

void ItineraryServices::overwriteItinerary(int id, QString name, QString departure, QStringList destinations, QString favorite, ServicesBase::CallbackType callback)
{
    CallbackType cb = [callback, id, name, departure, destinations, favorite, this] (int errorType, QString jsonStr) mutable
    {
        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        if (errorType == 0 && obj.value("id").toInt(-1) == id)
        {
            int oldDestinationsCount = obj.value("destinations").toArray().size();
            std::shared_ptr<int> destinationsCountdown(new int(oldDestinationsCount));

            CallbackType clearCb;
            clearCb = [callback, id, destinationsCountdown, clearCb, name, departure, destinations, favorite, this] (int errorType, QString jsonStr) mutable
            {
                if (destinationsCountdown && errorType == 0)
                {
                    --(*destinationsCountdown);
                    if (*destinationsCountdown <= 0)
                    {
                        CallbackType editCb = [callback, id, destinations, this] (int errorType, QString jsonStr) mutable
                        {
                            if (errorType == 0)
                            {
                                if (destinations.size() > 0)
                                {
                                    std::shared_ptr<int> currentPos(new int(0));

                                    CallbackType addDestinationCb;
                                    addDestinationCb = [callback, id, currentPos, addDestinationCb, destinations, this] (int errorType, QString jsonStr) mutable
                                    {
                                        if (currentPos && errorType == 0)
                                        {
                                            ++(*currentPos);
                                            if (*currentPos < destinations.size())
                                            {
                                                addDestination(id, destinations.first(), -1, addDestinationCb);
                                            }
                                            else
                                                callback(errorType, jsonStr);
                                        }
                                        else
                                            callback(errorType, jsonStr);
                                    };

                                    addDestination(id, destinations.first(), -1, addDestinationCb);
                                }
                                else
                                    callback(errorType, jsonStr);
                            }
                            else
                                callback(errorType, jsonStr);
                        };

                        editItinerary(id, name, departure, favorite, editCb);
                    }
                    else
                        deleteDestination(id, 0, clearCb);
                }
                else
                    callback(errorType, jsonStr);
            };

            if (oldDestinationsCount > 0)
                deleteDestination(id, 0, clearCb);
            else
                clearCb(errorType, jsonStr);
        }
        else
            callback(errorType, jsonStr);
    };

    getItinerary(id, cb);
}

void ItineraryServices::overwriteItinerary(int id, QString name, QString departure, QStringList destinations, QString favorite, QJSValue callback)
{
    overwriteItinerary(id, name, departure, destinations, favorite, fromJSCallback(callback));
}

void ItineraryServices::addDestination(int id, QString destination, int position, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations").arg(serverAddress).arg(id));

    QUrlQuery query;
    query.addQueryItem("destination", destination);
    if (position >= 0)
        query.addQueryItem("position", QString::number(position));
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());

    postRequest(url, query.query().toLocal8Bit(), callback);
}

void ItineraryServices::addDestination(int id, QString destination, int position, QJSValue callback)
{
    addDestination(id, destination, position, fromJSCallback(callback));
}

void ItineraryServices::editDestination(int id, int oldPosition, int newPosition, QString destination, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/itineraries/%2/destinations/%3").arg(serverAddress).arg(id).arg(oldPosition));

    QUrlQuery query;
    if (!destination.isEmpty())
        query.addQueryItem("destination", destination);
    if (newPosition >= 0)
        query.addQueryItem("position", QString::number(newPosition));
    if (!UserServices::getToken().isEmpty())
        query.addQueryItem("token", UserServices::getToken());
    url.setQuery(query.query());

    putRequest(url, QByteArray(), callback);
}

void ItineraryServices::editDestination(int id, int oldPosition, int newPosition, QString destination, QJSValue callback)
{
    editDestination(id, oldPosition, newPosition, destination, fromJSCallback(callback));
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
