TEMPLATE = app

QT += qml quick \
    location

CONFIG += c++11

SOURCES += main.cpp \
    geocoding.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    geocoding.h

