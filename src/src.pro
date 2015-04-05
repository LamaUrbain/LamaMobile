TEMPLATE = app

QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    mobilitydiagram.cpp \
    mapgetter.cpp \
    mapwidget.cpp \
    mapextension.cpp
RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mobilitydiagram.h \
    mapgetter.h \
    mapwidget.h \
    mapextension.h
