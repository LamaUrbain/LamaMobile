#include "mapwidgetprivate.h"
#include "mapextension.h"

MapExtension::MapExtension(MapWidget *map)
    : QObject(), _map(map)
{
}

MapExtension::~MapExtension()
{
}

bool MapExtension::wheelEvent(QWheelEvent *event)
{
    Q_UNUSED(event);
    return false;
}

bool MapExtension::mousePressEvent(QMouseEvent *event)
{
    Q_UNUSED(event);
    return false;
}

bool MapExtension::mouseReleaseEvent(QMouseEvent *event)
{
    Q_UNUSED(event);
    return false;
}

bool MapExtension::mouseMoveEvent(QMouseEvent *event)
{
    Q_UNUSED(event);
    return false;
}

bool MapExtension::touchEvent(QTouchEvent *event)
{
    Q_UNUSED(event);
    return false;
}

MapWidgetPrivate *MapExtension::getMapPrivate() const
{
    return _map->d_ptr;
}
