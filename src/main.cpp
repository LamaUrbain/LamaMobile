#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mapgetter.h"
#include "mapwidget.h"
#include "itineraryservices.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MapGetter>("MapControls", 1, 0, "MapGetter");
    qmlRegisterType<MapWidget>("MapControls", 1, 0, "MapWidget");

    ItineraryServices itineraryServices;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("itineraryServices", &itineraryServices);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
