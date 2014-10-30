SRC_PATH = ../../src

TEMPLATE = app
QT += qml quick

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
    mapwidget.cpp \
    quadtreetestrenderer.cpp

HEADERS += mapwidget.h \
    mapwidgetprivate.h \
    $$SRC_PATH/quadtree.h \
    quadtreetestrenderer.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
