#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonValue>
#include <QUrlQuery>
#include "eventservices.h"

EventServices *EventServices::_instance = NULL;

EventServices::EventServices()
{
    _instance = this;
}

EventServices::~EventServices()
{
}

EventServices *EventServices::getInstance()
{
    return _instance;
}

void EventServices::reportIncident(QString eventName, QString dateBegin, QString dateEnd, QString position, QString address, ServicesBase::CallbackType callback)
{
    if (eventName.isEmpty() || position.isEmpty())
    {
        callback(-1, "Internal Bad parameters");
        return;
    }

    QUrl url(QString("%1/incidents/").arg(serverAddress));
    QUrlQuery query;
    query.addQueryItem("name", eventName);
    query.addQueryItem("position", position);
    if (!dateBegin.isEmpty())
        query.addQueryItem("begin", dateBegin);
    if (!dateEnd.isEmpty())
        query.addQueryItem("end", dateEnd);
    if (!position.isEmpty())
        query.addQueryItem("position", position);
    if (!address.isEmpty())
        query.addQueryItem("address", address);

    postRequest(url, query.query().toLocal8Bit(), callback);
}

void EventServices::getIncidentList(ServicesBase::CallbackType callback) /*, QString dateBegin = NULL, QString dateEnd = NULL)*/
{ // Todo : give a period for pagination instead of loading everything
    QUrl url(QString("%1/incidents").arg(serverAddress));

    getRequest(url, callback);
}

void EventServices::reportIncident(QString eventName, QString dateBegin, QString dateEnd, QString position, QString adress, QJSValue callback)
{
    reportIncident(eventName, dateBegin, dateEnd, position, adress, fromJSCallback(callback));
}

void EventServices::getIncidentList(QJSValue callback)
{
    getIncidentList(fromJSCallback(callback));
}
