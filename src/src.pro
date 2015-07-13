TEMPLATE = app

QT += qml quick network

CONFIG += c++11

SOURCES += main.cpp \
    #mobilitydiagram.cpp \
    mapgetter.cpp \
    mapwidget.cpp \
    mapextension.cpp \
    servicesbase.cpp \
    itineraryservices.cpp \
    mapoverlayextension.cpp
RESOURCES += qml.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    #mobilitydiagram.h \
    mapgetter.h \
    mapwidget.h \
    mapextension.h \
    servicesbase.h \
    itineraryservices.h \
    mapoverlayextension.h \
    mapwidgetprivate.h \
    quadtree.h
