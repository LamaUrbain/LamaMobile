#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mapgetter.h"
#include "mapwidget.h"
#include "itineraryservices.h"
#include "userservices.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MapGetter>("MapControls", 1, 0, "MapGetter");
    qmlRegisterType<MapWidget>("MapControls", 1, 0, "MapWidget");

    ItineraryServices itineraryServices;
    UserServices userServices;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("itineraryServices", &itineraryServices);
    engine.rootContext()->setContextProperty("userServices", &userServices);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    try
    {
        return app.exec();
    }
    catch (std::exception e)
    {
        std::cout << e.what() << std::endl;
    }
    return (-1);
}
