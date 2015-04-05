#ifndef SERVICESBASE_H
#define SERVICESBASE_H

#include <QUrl>
#include <QObject>
#include <QJSValue>
#include <QNetworkAccessManager>

class ServicesBase : public QObject
{
    Q_OBJECT

public:
    ServicesBase(QObject *parent = 0);
    virtual ~ServicesBase();

public slots:
    void abortPendingRequests();

protected:
    void getRequest(const QUrl &url, QJSValue callback);
    void postRequest(const QUrl &url, const QByteArray &data, QJSValue callback);
    void deleteRequest(const QUrl &url, QJSValue callback);

private slots:
    void onRequestFinished();

private:
    void sendRequest(QNetworkAccessManager::Operation type, const QUrl &url, const QByteArray &data, QJSValue callback);

private:
    QObject *_callbackObj;
    QMap<QNetworkReply *, QJSValue> _pending;
    QNetworkAccessManager _manager;
};

#endif // SERVICESBASE_H
