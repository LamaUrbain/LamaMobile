#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mobilitydiagram.h"
#include "mapgetter.h"
#include "mapwidget.h"
#include "itineraryservices.h"
#include "userservices.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MobilityDiagram>("MobilityDiagram", 1, 0, "MobilityDiagram");
    qmlRegisterType<MapGetter>("MapControls", 1, 0, "MapGetter");
    qmlRegisterType<MapWidget>("MapControls", 1, 0, "MapWidget");

    UserServices userServices;
    ItineraryServices itineraryServices;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("userServices", &userServices);
    engine.rootContext()->setContextProperty("itineraryServices", &itineraryServices);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
