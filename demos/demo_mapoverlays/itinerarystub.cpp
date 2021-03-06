#include "itinerarystub.h"
#include "mapwidget.h"
#include "mapoverlayextension.h"

ItineraryStub::ItineraryStub(QObject *parent)
    : QObject(parent)
{
}

ItineraryStub::~ItineraryStub()
{
}

void ItineraryStub::initMapWidget(MapWidget *view)
{
    if (!view)
        return;

    MapOverlayExtension *ext = new MapOverlayExtension(view);

    static const int tilesCount = 4;
    static MapTile tiles[tilesCount] =
    {
        MapTile(15, QPoint(16596, 11273), MapPixmap(":/images/15-16596-11273.png")),
        MapTile(15, QPoint(16597, 11272), MapPixmap(":/images/15-16597-11272.png")),
        MapTile(15, QPoint(16597, 11273), MapPixmap(":/images/15-16597-11273.png")),
        MapTile(15, QPoint(16598, 11273), MapPixmap(":/images/15-16598-11273.png"))
    };

    for (int i = 0; i < tilesCount; ++i)
        ext->addTile(tiles[i]);

    ext->appendPoint(QPointF(2.33944, 48.85222));
    ext->appendPoint(QPointF(2.35718, 48.85346));

    view->addExtension(ext);
}
