#ifndef MAPEVENTSOVERLAY_H
#define MAPEVENTSOVERLAY_H

#include <QObject>
#include "mapextension.h"
#include "mapoverlayextension.h"

class MapEventsOverlay : public MapOverlayExtension
{
    Q_OBJECT

public:
    MapEventsOverlay(MapWidget* map);
    virtual ~MapEventsOverlay();

    void updateEvents();

    virtual bool mousePressEvent(QMouseEvent *event);
    virtual bool mouseReleaseEvent(QMouseEvent *event);
    virtual bool mouseMoveEvent(QMouseEvent *event);
signals:
    void eventSelected(int id, QPointF coords);

private:

    struct Event
    {
        QPointF coordinate;
        int id;
    };

    QList<Event> _events;

};

#endif // MAPEVENTSOVERLAY_H
