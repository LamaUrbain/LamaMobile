#ifndef MAPGETTER_H
#define MAPGETTER_H

#include <QObject>
#include <QNetworkAccessManager>

class MapWidget;

class MapGetter : public QObject
{
    Q_OBJECT

private:
    struct Getter
    {
        QNetworkAccessManager _manager;
        QList<QPoint> _pending;
    };

public:
    MapGetter(QObject *parent = 0);
    virtual ~MapGetter();

public slots:
    void setWidget(MapWidget *widget);

private slots:
    void onTilesRequired();
    void onRequestFinished(QNetworkReply *reply);

private:
    Getter *getNextGetter() const;
    Getter *getManagerGetter(QNetworkAccessManager *manager) const;

private:
    MapWidget *_widget;
    QList<Getter *> _getters;
    QList<QPoint> _pending;
};

#endif // MAPGETTER_H
