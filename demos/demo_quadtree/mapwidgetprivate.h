#ifndef MAPWIDGETPRIVATE_H
#define MAPWIDGETPRIVATE_H

#include "mapwidget.h"

class MapWidgetPrivate
{
    Q_DECLARE_PUBLIC(MapWidget)

public:
    MapWidgetPrivate(MapWidget *ptr);
    virtual ~MapWidgetPrivate();

    void addTile(int zoomLevel, const QRectF &rect, const QPixmap &tile);
    void removeTiles(int zoomLevel, const QRectF &rect);
    void paint(QPainter *painter);

private:
    MapWidget * const q_ptr;
};

#endif // MAPWIDGETPRIVATE_H
