#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mapgetter.h"
#include "mapwidget.h"
#include "itineraryservices.h"
#include "userservices.h"
#include "geolocator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MapWidget>("MapControls", 1, 0, "MapWidget");
    qmlRegisterSingletonType(QUrl("qrc:/Components/ApplicationFont.qml"), "App", 1, 0, "ApplicationFont");

    GeoLocator geolocator;
    ItineraryServices itineraryServices;
    UserServices userServices;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("geolocator", &geolocator);
    engine.rootContext()->setContextProperty("itineraryServices", &itineraryServices);
    engine.rootContext()->setContextProperty("userServices", &userServices);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
