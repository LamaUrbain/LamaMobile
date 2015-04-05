#include <QNetworkReply>
#include <QNetworkRequest>
#include "servicesbase.h"

ServicesBase::ServicesBase(QObject *parent)
    : QObject(parent)
{
}

ServicesBase::~ServicesBase()
{
}

void ServicesBase::abortPendingRequests()
{
    for (QMap<QNetworkReply *, QJSValue>::iterator it = _pending.begin(); it != _pending.end(); )
    {
        QNetworkReply *reply = it.key();

        if (reply)
        {
            disconnect(reply, SIGNAL(finished()), this, SLOT(onRequestFinished()));
            disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onRequestFinished()));

            reply->abort();
            reply->deleteLater();
        }

        _pending.remove(reply);
    }
}

void ServicesBase::getRequest(const QUrl &url, QJSValue callback)
{
    sendRequest(QNetworkAccessManager::GetOperation, url, QByteArray(), callback);
}

void ServicesBase::postRequest(const QUrl &url, const QByteArray &data, QJSValue callback)
{
    sendRequest(QNetworkAccessManager::PostOperation, url, data, callback);
}

void ServicesBase::deleteRequest(const QUrl &url, QJSValue callback)
{
    sendRequest(QNetworkAccessManager::DeleteOperation, url, QByteArray(), callback);
}

void ServicesBase::onRequestFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply && _pending.contains(reply))
    {
        QJSValue callback = _pending.value(reply);

        if (callback.isCallable())
            callback.call(QJSValueList() << QJSValue(QString(reply->readAll())));

        _pending.remove(reply);
        reply->deleteLater();
    }
}

void ServicesBase::sendRequest(QNetworkAccessManager::Operation type, const QUrl &url, const QByteArray &data, QJSValue callback)
{
    QNetworkRequest request(url);
    QNetworkReply *reply = NULL;

    switch (type)
    {
        case QNetworkAccessManager::GetOperation:
            reply = _manager.get(request);
            break;
        case QNetworkAccessManager::PostOperation:
            reply = _manager.post(request, data);
            break;
        case QNetworkAccessManager::DeleteOperation:
            reply = _manager.deleteResource(request);
            break;
        default:
            break;
    }

    if (reply)
    {
        connect(reply, SIGNAL(finished()), this, SLOT(onRequestFinished()));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onRequestFinished()));

        _pending[reply] = callback;
    }
}
