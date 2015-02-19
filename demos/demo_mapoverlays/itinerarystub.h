#ifndef ITINERARYSTUB_H
#define ITINERARYSTUB_H

#include <QObject>

class MapWidget;

class ItineraryStub : public QObject
{
    Q_OBJECT

public:
    ItineraryStub(QObject *parent = 0);
    virtual ~ItineraryStub();

public slots:
    void initMapWidget(MapWidget *view);
};

#endif // ITINERARYSTUB_H
