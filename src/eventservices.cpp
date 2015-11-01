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

void EventServices::reportIncident(QString username, QString dateBegin, QString dateEnd, QString position, QString address, ServicesBase::CallbackType callback)
{
    if (username.isEmpty() || dateBegin.isEmpty() || (position.isEmpty() && address.isEmpty()))
    {
        callback.call(-1, "Bad parameters");
        return;
    }

    CallbackType cb = [callback, this] (int errorType, QString jsonStr) mutable
    {
        if (errorType == 0)
        {
            QJsonParseError error;
            QJsonDocument::fromJson(jsonStr.toLatin1(), &error);
            if (error.error != QJsonParseError::NoError)
            {
                errorType = -1;
                jsonStr = QString("Response is not JSON");
            }
        }

        callback(errorType, jsonStr);
    };

    QUrl url(QString("/incidents/"));
    QUrlQuery query;
    query.addQueryItem("name", username);
    query.addQueryItem("begin", dateBegin);
    query.addQueryItem("end", dateEnd.isEmpty() ? NULL : dateEnd);
    query.addQueryItem("position", position);
    query.addQueryItem("address", address);

    postRequest(url, query.query().toLocal8Bit(), cb);
}

void EventServices::sendFeedback(QString username, QString rateScore, QString message, ServicesBase::CallbackType callback)
{
    if (username.isEmpty() || rateScore.isEmpty() || message.isEmpty())
    {
        callback.call(-1, "Bad parameters");
        return;
    }

    QUrl url(QString("/feedback/"));
    QUrlQuery query;
    query.addQueryItem("name", username);
    query.addQueryItem("rateScore", rateScore);
    query.addQueryItem("message", message);

    postRequest(url, query.query().toLocal8Bit(), callback);
}

void EventServices::getIncidentList(ServicesBase::CallbackType callback) /*, QString dateBegin = NULL, QString dateEnd = NULL)*/
{ // Todo : give a period for pagination instead of loading everything
    CallbackType cb = [callback, this] (int errorType, QString jsonStr) mutable
    {
        if (errorType == 0)
        {
            QJsonParseError error;
            QJsonDocument::fromJson(jsonStr.toLatin1(), &error);
            if (error.error != QJsonParseError::NoError)
            {
                errorType = -1;
                jsonStr = QString("Response is not JSON");
            }
        }

        callback(errorType, jsonStr);
    };

    QUrl url(QString("/incidents/"));

    getRequest(url, cb);
}

void EventServices::reportIncident(QString username, QString dateBegin, QString dateEnd, QString position, QString adress, QJSValue callback)
{
    reportIncident(username, dateBegin, dateEnd, position, adress, fromJSCallback(callback));
}

void EventServices::sendFeedback(QString username, QString rateScore, QString message, QJSValue callback)
{
    sendFeedback(username, rateScore, message, fromJSCallback(callback));
}

void EventServices::getIncidentList(QJSValue callback)
{
    getIncidentList(fromJSCallback(callback));
}
