#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mapwidget.h"
#include "mapgetter.h"
#include "itinerarystub.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MapWidget>("Tests", 1, 0, "MapWidget");
    qmlRegisterType<MapGetter>("Tests", 1, 0, "MapGetter");
    qmlRegisterType<ItineraryStub>("Tests", 1, 0, "ItineraryStub");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
