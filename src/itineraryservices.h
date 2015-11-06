#ifndef ITINERARYSERVICES_H
#define ITINERARYSERVICES_H

#include <QObject>
#include <memory>
#include "servicesbase.h"

class ItineraryServices : public ServicesBase
{
    Q_OBJECT

public:
    ItineraryServices();
    virtual ~ItineraryServices();
    static ItineraryServices *getInstance();

    void getItineraries(QString search, QString username, QString favorite, QString ordering, ServicesBase::CallbackType callback);
    void getItinerary(int id, ServicesBase::CallbackType callback);
    void createItinerary(QString name, QString departure, QString departure_address, QString destination, QString destination_address, QString favorite, ServicesBase::CallbackType callback);
    void editItinerary(int id, QString name, QString departure, QString departure_address, QString favorite, ServicesBase::CallbackType callback);
    void addDestination(int id, QString destination, QString destination_address, int position, ServicesBase::CallbackType callback);
    void editDestination(int id, int oldPosition, int newPosition, QString destination, QString destination_address, ServicesBase::CallbackType callback);
    void deleteDestination(int id, int position, ServicesBase::CallbackType callback);
    void deleteItinerary(int id, ServicesBase::CallbackType callback);
    void getItineraryTiles(int id, int zoomLevel, ServicesBase::CallbackType callback);

public slots:
    void getItineraries(QString search, QString username, QString favorite, QString ordering, QJSValue callback);
    void getItinerary(int id, QJSValue callback);
    void createItinerary(QString name, QString departure, QString departure_address, QString destination, QString destination_address, QString favorite, QJSValue callback);
    void editItinerary(int id, QString name, QString departure, QString departure_address, QString favorite, QJSValue callback);
    void addDestination(int id, QString destination, QString destination_address, int position, QJSValue callback);
    void editDestination(int id, int oldPosition, int newPosition, QString destination, QString destination_address, QJSValue callback);
    void deleteDestination(int id, int position, QJSValue callback);
    void deleteItinerary(int id, QJSValue callback);
    void getItineraryTiles(int id, int zoomLevel, QJSValue callback);

private:
    static ItineraryServices *_instance;
};

#endif // ITINERARYSERVICES_H
