#include <QNetworkReply>
#include <QNetworkRequest>
#include "servicesbase.h"

const QString ServicesBase::serverAddress = QStringLiteral("http://api.lamaurba.in");

ServicesBase::ServicesBase(QObject *parent)
    : QObject(parent)
{
}

ServicesBase::~ServicesBase()
{
}

void ServicesBase::abortPendingRequests()
{
    for (QMap<QNetworkReply *, CallbackType>::iterator it = _pending.begin(); it != _pending.end(); )
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

ServicesBase::CallbackType ServicesBase::fromJSCallback(QJSValue callback)
{
    CallbackType cb = [callback] (int errorType, QString jsonStr) mutable
    {
        if (callback.isCallable())
        {
            QJSValueList args;
            args << QJSValue(errorType) << QJSValue(jsonStr);
            QJSValue result = callback.call(args);
            if (result.isError())
            {
                QString errorString = QString("%1:%2: %3")
                        .arg(result.property("fileName").toString())
                        .arg(result.property("lineNumber").toInt())
                        .arg(result.toString());
                qWarning() << errorString.toUtf8().constData();
            }
        }
    };
    return cb;
}

void ServicesBase::getRequest(const QUrl &url, CallbackType callback)
{
    sendRequest(QNetworkAccessManager::GetOperation, url, QByteArray(), callback);
}

void ServicesBase::postRequest(const QUrl &url, const QByteArray &data, CallbackType callback)
{
    sendRequest(QNetworkAccessManager::PostOperation, url, data, callback);
}

void ServicesBase::putRequest(const QUrl &url, const QByteArray &data, CallbackType callback)
{
    sendRequest(QNetworkAccessManager::PutOperation, url, data, callback);
}

void ServicesBase::deleteRequest(const QUrl &url, CallbackType callback)
{
    sendRequest(QNetworkAccessManager::DeleteOperation, url, QByteArray(), callback);
}

void ServicesBase::onRequestFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply && _pending.contains(reply))
    {
        QString result = reply->readAll();
        qDebug() << "Reply:" << (int)reply->error() << result;
        CallbackType callback = _pending.value(reply);
        callback(static_cast<int>(reply->error()), result);
        _pending.remove(reply);
        reply->deleteLater();
    }
}

void ServicesBase::sendRequest(QNetworkAccessManager::Operation type, const QUrl &url, const QByteArray &data, CallbackType callback)
{
    QNetworkRequest request(url);
    QNetworkReply *reply = NULL;

    switch (type)
    {
        case QNetworkAccessManager::GetOperation:
            qDebug() << "GET:" << url.toString();
            reply = _manager.get(request);
            break;
        case QNetworkAccessManager::PostOperation:
            request.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
            request.setRawHeader("X-Custom-User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
            request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
            request.setRawHeader("Content-Length", QByteArray::number(data.size()));
            qDebug() << "POST:" << url.toString() << "- Body:" << data;
            reply = _manager.post(request, data);
            break;
        case QNetworkAccessManager::PutOperation:
            request.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
            request.setRawHeader("X-Custom-User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0");
            request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
            request.setRawHeader("Content-Length", QByteArray::number(data.size()));
            qDebug() << "PUT:" << url.toString() << "- Body:" << data;
            reply = _manager.put(request, data);
            break;
        case QNetworkAccessManager::DeleteOperation:
            qDebug() << "DELETE:" << url.toString();
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
