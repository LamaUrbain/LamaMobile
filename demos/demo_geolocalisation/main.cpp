#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "geocoding.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    geoCoding geoCoding;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("geoCodingManager", &geoCoding);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

