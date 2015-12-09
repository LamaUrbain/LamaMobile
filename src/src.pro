TEMPLATE = app

QT += qml quick network positioning location sql

CONFIG += c++11

SOURCES += main.cpp \
    mapgetter.cpp \
    mapwidget.cpp \
    mapextension.cpp \
    servicesbase.cpp \
    itineraryservices.cpp \
    mapoverlayextension.cpp \
    userservices.cpp \
    eventservices.cpp \
    geolocator.cpp \
    mapeventsoverlay.cpp
RESOURCES += qml.qrc \
    images.qrc \
    fonts.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += mapgetter.h \
    mapwidget.h \
    mapextension.h \
    servicesbase.h \
    itineraryservices.h \
    mapoverlayextension.h \
    mapwidgetprivate.h \
    quadtree.h \
    userservices.h \
    eventservices.h \
    geolocator.h \
    mapeventsoverlay.h
