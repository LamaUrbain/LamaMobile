#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonParseError>
#include <QJsonObject>

#include "mapeventsoverlay.h"
#include "eventservices.h"

MapEventsOverlay::MapEventsOverlay(MapWidget* map):
    MapOverlayExtension(map)
{
}


MapEventsOverlay::~MapEventsOverlay()
{
}

// update all events, yipi !!
void MapEventsOverlay::updateEvents()
{
    EventServices* eservices = EventServices::getInstance();

    eservices->getIncidentList([this] (int errorType, QString jsonStr) mutable {
        if (errorType != 0)
        {
            qDebug() << "getIncidentList failed:" << errorType;
            return;
        }

        QJsonParseError error;
        QJsonDocument document = QJsonDocument::fromJson(jsonStr.toUtf8(), &error);
        if (error.error != QJsonParseError::NoError)
        {
            qDebug() << jsonStr << ":" << error.errorString();
            return ;
        }

        this->_events.clear();

        QJsonArray events = document.array();
        for (QJsonValueRef const& eref: events)
        {
            QJsonObject obj = eref.toObject();
            QString name = obj.value("name").toString();
            int id = obj.value("id").toInt();
            QString event_begin = obj.value("begin").toString();
            QString event_end = obj.value("end").toString();

            QJsonObject event_pos = obj.value("position").toObject();
            {
                QString addr = event_pos.value("addres").toString();
                double latitude = event_pos.value("latitude").toDouble();
                double longitude = event_pos.value("longitude").toDouble();
                this->appendPoint(QPointF{longitude, latitude});
                this->_events.append({QPointF{longitude, latitude}, id});
            }
        }
    });
}

bool MapEventsOverlay::mousePressEvent(QMouseEvent *event)
{
    if (_selectedPoint != -1)
        return false;

    int point = pointAt(event->pos());

    if (point != -1)
        return true;

    _selectedPoint = -1;
    return false;
}

bool MapEventsOverlay::mouseReleaseEvent(QMouseEvent *event)
{
    Q_UNUSED(event);

    if (_selectedPoint != -1)
    {
        _selectedPoint = -1;
        _map->repaint();
        return true;
    }

    int point = pointAt(event->pos());

    if (point == -1)
        return false;

    Event const& E = this->_events.at(point);
    emit eventSelected(E.id, E.coordinate);

    _selectedPoint = point;
    _map->repaint();
    return true;
}

bool MapEventsOverlay::mouseMoveEvent(QMouseEvent *event)
{
    Q_UNUSED(event);
    return false;
}
