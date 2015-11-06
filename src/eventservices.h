#ifndef EVENTSERVICES_H
#define EVENTSERVICES_H

#include <QObject>
#include "servicesbase.h"

class EventServices : public ServicesBase
{
     Q_OBJECT

public:
    EventServices();
    ~EventServices();
    static EventServices *getInstance();

    void reportIncident(QString username, QString dateBegin, QString dateEnd, QString position, QString address, ServicesBase::CallbackType callback);
    void getIncidentList(ServicesBase::CallbackType callback);

public slots:
    void reportIncident(QString username, QString dateBegin, QString dateEnd, QString position, QString address, QJSValue callback);
    void getIncidentList(QJSValue callback);/*, QString dateBegin, QString dateEnd);*/ // Todo : give a period for pagination instead of loading everything

private:
    static EventServices *_instance;

};

#endif // EVENTSERVICES_H
