#ifndef SERVICESBASE_H
#define SERVICESBASE_H

#include <QUrl>
#include <QObject>
#include <QJSValue>
#include <QNetworkAccessManager>

#include <functional>

class ServicesBase : public QObject
{
    Q_OBJECT

public:
    typedef std::function<void(int, QString)> CallbackType;

    ServicesBase(QObject *parent = 0);
    virtual ~ServicesBase();

public slots:
    void abortPendingRequests();

protected:
    CallbackType fromJSCallback(QJSValue callback);

    void getRequest(const QUrl &url, CallbackType callback);
    void postRequest(const QUrl &url, const QByteArray &data, CallbackType callback);
    void putRequest(const QUrl &url, const QByteArray &data, CallbackType callback);
    void deleteRequest(const QUrl &url, CallbackType callback);

private slots:
    void onRequestFinished();

private:
    void sendRequest(QNetworkAccessManager::Operation type, const QUrl &url, const QByteArray &data, CallbackType callback);

private:
    QObject *_callbackObj;
    QMap<QNetworkReply *, CallbackType> _pending;
    QNetworkAccessManager _manager;
};

#endif // SERVICESBASE_H
