#ifndef MAPGETTER_H
#define MAPGETTER_H

#include <QObject>
#include <QNetworkAccessManager>

class MapWidget;

class MapGetter : public QObject
{
    Q_OBJECT

public:
    MapGetter(QObject *parent = 0);
    virtual ~MapGetter();

public slots:
    void setWidget(MapWidget *widget);

private slots:
    void onTilesRequired();
    void onRequestFinished(QNetworkReply *reply);

private:
    MapWidget *_widget;
    QNetworkAccessManager _manager;
    QList<QPoint> _pending;
};

#endif // MAPGETTER_H
