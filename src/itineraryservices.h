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
    static ItineraryServices *getInstance();

    void createItinerary(QVariantList points, ServicesBase::CallbackType callback); // TODO: settings
    void deleteItinerary(int id, ServicesBase::CallbackType callback);
    void getItinerary(int id, int zoomLevel, ServicesBase::CallbackType callback);

public slots:
    void createItinerary(QVariantList points, QJSValue callback); // TODO: settings
    void deleteItinerary(int id, QJSValue callback);
    void getItinerary(int id, int zoomLevel, QJSValue callback);

private:
    static ItineraryServices *_instance;
};

#endif // ITINERARYSERVICES_H
