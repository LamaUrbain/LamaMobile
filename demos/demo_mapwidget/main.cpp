#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mapwidget.h"
#include "mapwidgetstub.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MapWidget>("Tests", 1, 0, "MapWidget");

    MapWidgetStub stub;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("stub", &stub);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
