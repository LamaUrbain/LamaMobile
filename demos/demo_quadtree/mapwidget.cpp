#include "mapwidget.h"
#include "mapwidgetprivate.h"

MapWidgetPrivate::MapWidgetPrivate(MapWidget *ptr)
    : q_ptr(ptr)
{
}

MapWidgetPrivate::~MapWidgetPrivate()
{
}

void MapWidgetPrivate::paint(QPainter *painter)
{
    if (painter)
    {
    }
}

MapWidget::MapWidget(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      d_ptr(new MapWidgetPrivate(this))
{
}

MapWidget::~MapWidget()
{
    delete d_ptr;
}

void MapWidget::paint(QPainter *painter)
{
    Q_D(MapWidget);
    d->paint(painter);
}
