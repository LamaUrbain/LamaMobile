SRC_PATH = ../../src

OBJECTS_DIR = demo_mapwidget_obj
MOC_DIR = demo_mapwidget_moc

TEMPLATE = app
QT += qml quick

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
    $$SRC_PATH/mapwidget.cpp \
    mapwidgetstub.cpp

HEADERS += $$SRC_PATH/mapwidget.h \
    $$SRC_PATH/mapwidgetprivate.h \
    mapwidgetstub.h

RESOURCES += qml.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
