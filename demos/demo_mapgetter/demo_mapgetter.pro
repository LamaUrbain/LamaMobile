SRC_PATH = ../../src

OBJECTS_DIR = demo_mapgetter_obj
MOC_DIR = demo_mapgetter_moc

TEMPLATE = app
QT += qml quick network

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
    $$SRC_PATH/mapwidget.cpp \
    $$SRC_PATH/mapgetter.cpp

HEADERS += $$SRC_PATH/mapwidget.h \
    $$SRC_PATH/mapwidgetprivate.h \
    $$SRC_PATH/mapgetter.h

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
