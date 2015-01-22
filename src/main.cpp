#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mobilitydiagram.h"
#include "mapgetter.h"
#include "mapwidget.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MobilityDiagram>("MobilityDiagram", 1, 0, "MobilityDiagram");
    qmlRegisterType<MapGetter>("MapControls", 1, 0, "MapGetter");
    qmlRegisterType<MapWidget>("MapControls", 1, 0, "MapWidget");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
