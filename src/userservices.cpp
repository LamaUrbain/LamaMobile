#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonValue>
#include <QUrlQuery>
#include "userservices.h"

UserServices *UserServices::_instance = NULL;

UserServices::UserServices()
{
    _instance = this;
}

UserServices::~UserServices()
{
}

UserServices *UserServices::getInstance()
{
    return _instance;
}

const QString &UserServices::getToken()
{
    return getInstance()->_token;
}

void UserServices::getUsers(QString search, QString sponsored, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/").arg(serverAddress));

    QUrlQuery query;
    if (!search.isEmpty())
        query.addQueryItem("search", search);
    if (!sponsored.isEmpty())
        query.addQueryItem("sponsored", sponsored == "true" ? "true" : "false");
    url.setQuery(query.query());

    getRequest(url, callback);
}

void UserServices::getUsers(QString search, QString sponsored, QJSValue callback)
{
    getUsers(search, sponsored, fromJSCallback(callback));
}

void UserServices::getUser(QString username, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/%2").arg(serverAddress).arg(username));
    getRequest(url, callback);
}

void UserServices::getUser(QString username, QJSValue callback)
{
    getUser(username, fromJSCallback(callback));
}

void UserServices::createUser(QString username, QString password, QString email, bool sponsor, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/").arg(serverAddress));

    QUrlQuery query;
    query.addQueryItem("username", username);
    query.addQueryItem("password", password);
    query.addQueryItem("email", email);
    query.addQueryItem("sponsor", sponsor ? "true" : "false");

    postRequest(url, query.query().toUtf8(), callback);
}

void UserServices::createUser(QString username, QString password, QString email, bool sponsor, QJSValue callback)
{
    createUser(username, password, email, sponsor, fromJSCallback(callback));
}

void UserServices::editUser(QString username, QString password, QString email, QString sponsor, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/%2").arg(serverAddress).arg(username));

    QUrlQuery query;
    if (!password.isEmpty())
        query.addQueryItem("password", password);
    if (!email.isEmpty())
        query.addQueryItem("email", email);
    if (!sponsor.isEmpty())
        query.addQueryItem("sponsor", sponsor == "true" ? "true" : "false");
    if (!_token.isEmpty())
        query.addQueryItem("token", _token);
    url.setQuery(query.query());

    putRequest(url, QByteArray(), callback);
}

void UserServices::editUser(QString username, QString password, QString email, QString sponsor, QJSValue callback)
{
    editUser(username, password, email, sponsor, fromJSCallback(callback));
}

void UserServices::deleteUser(QString username, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/%2").arg(serverAddress).arg(username));

    if (!_token.isEmpty())
    {
        QUrlQuery query;
        query.addQueryItem("token", _token);
        url.setQuery(query.query());
    }

    deleteRequest(url, callback);
}

void UserServices::deleteUser(QString username, QJSValue callback)
{
    deleteUser(username, fromJSCallback(callback));
}

void UserServices::createToken(QString username, QString password, ServicesBase::CallbackType callback)
{
    CallbackType cb = [callback, this] (int errorType, QString jsonStr) mutable
    {
        if (errorType == 0)
        {
            QJsonParseError error;
            QJsonDocument document = QJsonDocument::fromJson(jsonStr.toUtf8(), &error);

            if (error.error == QJsonParseError::NoError)
            {
                QJsonObject obj = document.object();
                QJsonValue token = obj.value("token");
                if (token.isString())
                    _token = token.toString();
            }
        }

        callback(errorType, jsonStr);
    };

    QUrl url(QString("%1/sessions/").arg(serverAddress));

    QUrlQuery query;
    query.addQueryItem("username", username);
    query.addQueryItem("password", password);

    postRequest(url, query.query().toUtf8(), cb);
}

void UserServices::createToken(QString username, QString password, QJSValue callback)
{
    createToken(username, password, fromJSCallback(callback));
}

void UserServices::deleteToken(ServicesBase::CallbackType callback)
{
    CallbackType cb = [callback, this] (int errorType, QString jsonStr) mutable
    {
        if (errorType == 0)
            _token.clear();

        callback(errorType, jsonStr);
    };

    QUrl url(QString("%1/sessions/%2").arg(serverAddress).arg(_token));
    deleteRequest(url, cb);
}

void UserServices::deleteToken(QJSValue callback)
{
    deleteToken(fromJSCallback(callback));
}
