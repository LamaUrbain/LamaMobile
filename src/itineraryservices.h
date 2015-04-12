#ifndef ITINERARYSERVICES_H
#define ITINERARYSERVICES_H

#include <QObject>
#include "servicesbase.h"

class ItineraryServices : public ServicesBase
{
    Q_OBJECT

public:
    ItineraryServices();
    virtual ~ItineraryServices();

public slots:
    void createItinerary(QVariantList points, QJSValue callback); // TODO: settings
    void deleteItinerary(int id, QJSValue callback);
    void getItinerary(int id, int zoomLevel, QJSValue callback);
};

#endif // ITINERARYSERVICES_H
