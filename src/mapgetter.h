#ifndef MAPGETTER_H
#define MAPGETTER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QPoint>

class MapWidget;
class MapOverlayExtension;

class MapGetter : public QObject
{
    Q_OBJECT

private:
    struct Tile
    {
        Tile();
        Tile(const QPoint &p, quint8 s, MapOverlayExtension *ext = 0);
        Tile(const Tile &other);
        Tile &operator=(const Tile &other);
        bool operator==(const Tile &other);

        QPoint pos;
        quint8 scale;
        QNetworkReply *reply;
        MapOverlayExtension *extension;
    };

    struct Getter
    {
        QNetworkAccessManager _manager;
        QList<Tile> _pending;
    };

public:
    MapGetter(QObject *parent = 0);
    virtual ~MapGetter();

    const QList<MapOverlayExtension *> &getExtensions() const;
    void addExtension(MapOverlayExtension *ext);
    void removeExtension(MapOverlayExtension *ext);

signals:
    void tileReceived();

public slots:
    void setWidget(MapWidget *widget);

private slots:
    void onTilesRequired();
    void onRequestFinished(QNetworkReply *reply);
    void cancelRequests();

private:
    Getter *getNextGetter() const;
    Getter *getManagerGetter(QNetworkAccessManager *manager) const;

private:
    MapWidget *_widget;
    QList<Getter *> _getters;
    QList<Tile> _pending;
    QList<Tile> _errors;
    QList<QNetworkReply *> _replies;
    QList<MapOverlayExtension *> _extensions;
};

#endif // MAPGETTER_H
