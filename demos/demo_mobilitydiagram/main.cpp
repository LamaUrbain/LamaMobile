#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mobilitydiagram.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<MobilityDiagram>("MobilityDiagramTest", 1, 0, "MobilityDiagram");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
