#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "quadtreetestrenderer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QuadtreeTestRenderer>("Tests", 1, 0, "QuadtreeTestRenderer");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
