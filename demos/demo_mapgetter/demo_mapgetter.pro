SRC_PATH = ../../src

OBJECTS_DIR = demo_mapgetter_obj
MOC_DIR = demo_mapgetter_moc

TEMPLATE = app
QT += qml quick network
CONFIG += c++11

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
    $$SRC_PATH/mapwidget.cpp \
    $$SRC_PATH/mapgetter.cpp \
    $$SRC_PATH/mapextension.cpp \
    $$SRC_PATH/servicesbase.cpp \
    $$SRC_PATH/itineraryservices.cpp \
    $$SRC_PATH/userservices.cpp \
    $$SRC_PATH/mapoverlayextension.cpp

HEADERS += $$SRC_PATH/mapwidget.h \
    $$SRC_PATH/mapwidgetprivate.h \
    $$SRC_PATH/mapgetter.h \
    $$SRC_PATH/mapextension.h \
    $$SRC_PATH/servicesbase.h \
    $$SRC_PATH/itineraryservices.h \
    $$SRC_PATH/userservices.h \
    $$SRC_PATH/mapoverlayextension.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)


winrt {
    WINRT_MANIFEST.publisher = "LamaUrbain"
    winphone:equals(WINSDK_VER, 8.1) {
        WINRT_MANIFEST.capabilities += ID_CAP_NETWORKING
        WINRT_MANIFEST.capabilities += ID_CAP_LOCATION
        WINRT_MANIFEST.capabilities += ID_CAP_MAP
    } else {
        WINRT_MANIFEST.capabilities += internetClient
    }
}
