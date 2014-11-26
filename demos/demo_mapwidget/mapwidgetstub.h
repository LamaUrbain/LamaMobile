#ifndef MAPWIDGETSTUB_H
#define MAPWIDGETSTUB_H

#include <QObject>

class MapWidget;

class MapWidgetStub : public QObject
{
    Q_OBJECT

public:
    MapWidgetStub(QObject *parent = 0);

public slots:
    void initMapWidget(MapWidget *view);
};

#endif // MAPWIDGETSTUB_H
