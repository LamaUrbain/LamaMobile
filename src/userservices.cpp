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


void UserServices::getUsers(QString search, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/").arg(serverAddress));


    QUrlQuery query;
    if (!search.isEmpty())
        query.addQueryItem("search", search);
    url.setQuery(query.query());


    getRequest(url, callback);
}


void UserServices::getUsers(QString search, QJSValue callback)
{
    getUsers(search, fromJSCallback(callback));
}


void UserServices::getUser(QString username, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/%2/").arg(serverAddress).arg(username));
    getRequest(url, callback);
}


void UserServices::getUser(QString username, QJSValue callback)
{
    getUser(username, fromJSCallback(callback));
}


void UserServices::createUser(QString username, QString password, QString email, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/").arg(serverAddress));


    QUrlQuery query;
    query.addQueryItem("username", username);
    query.addQueryItem("password", password);
    query.addQueryItem("email", email);


    postRequest(url, query.query().toLocal8Bit(), callback);
}


void UserServices::createUser(QString username, QString password, QString email, QJSValue callback)
{
    createUser(username, password, email, fromJSCallback(callback));
}


void UserServices::editUser(QString username, QString password, QString email, ServicesBase::CallbackType callback)
{
    QUrl url(QString("%1/users/%2/").arg(serverAddress).arg(username));


    QUrlQuery query;
    if (!password.isEmpty())
        query.addQueryItem("password", password);
    if (!email.isEmpty())
        query.addQueryItem("email", email);
    if (!_token.isEmpty())
        query.addQueryItem("token", _token);
    url.setQuery(query.query());


    putRequest(url, QByteArray(), callback);
}


void UserServices::editUser(QString username, QString password, QString email, QJSValue callback)
{
    editUser(username, password, email, fromJSCallback(callback));
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
            QJsonDocument document = QJsonDocument::fromJson(jsonStr.toLatin1(), &error);


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


    postRequest(url, query.query().toLocal8Bit(), cb);
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

