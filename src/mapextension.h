#ifndef MAPEXTENSION
#define MAPEXTENSION

#include <QPainter>
#include <QPoint>
#include <QWheelEvent>
#include <QMouseEvent>
#include <QTouchEvent>

class MapWidget;

class MapExtension
{
public:
    MapExtension(MapWidget *map);
    virtual ~MapExtension();

    virtual void begin(QPainter *painter) = 0;
    virtual void drawTile(QPainter *painter, const QPoint &pos, const QPoint &tilePos) = 0;
    virtual void end(QPainter *painter) = 0;

    virtual bool wheelEvent(QWheelEvent *event);
    virtual bool mousePressEvent(QMouseEvent *event);
    virtual bool mouseReleaseEvent(QMouseEvent *event);
    virtual bool mouseMoveEvent(QMouseEvent *event);
    virtual bool touchEvent(QTouchEvent *event);

protected:
    MapWidget *_map;
};

#endif // MAPEXTENSION
