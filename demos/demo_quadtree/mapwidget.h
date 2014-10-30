#ifndef MAPWIDGET_H
#define MAPWIDGET_H

#include <QQuickPaintedItem>

class MapWidgetPrivate;

class MapWidget : public QQuickPaintedItem
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(MapWidget)

public:
    MapWidget(QQuickItem *parent = 0);
    virtual ~MapWidget();

    void addTile(int zoomLevel, const QRectF &rect, const QPixmap &tile);
    virtual void paint(QPainter *painter);

private:
    MapWidgetPrivate * const d_ptr;
};

#endif // MAPWIDGET_H
