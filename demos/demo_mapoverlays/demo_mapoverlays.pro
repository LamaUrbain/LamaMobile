SRC_PATH = ../../src

TEMPLATE = app
QT += qml quick network

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
    $$SRC_PATH/mapwidget.cpp \
    $$SRC_PATH/mapgetter.cpp \
    $$SRC_PATH/mapextension.cpp \
    $$SRC_PATH/mapoverlayextension.cpp \
    itinerarystub.cpp

HEADERS += $$SRC_PATH/mapwidget.h \
    $$SRC_PATH/mapwidgetprivate.h \
    $$SRC_PATH/mapgetter.h \
    $$SRC_PATH/mapextension.h \
    $$SRC_PATH/mapoverlayextension.h \
    itinerarystub.h

RESOURCES += qml.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
