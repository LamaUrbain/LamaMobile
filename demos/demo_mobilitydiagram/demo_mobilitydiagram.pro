SRC_PATH = ../../src

TEMPLATE = app
QT += qml quick
CONFIG += c++11

INCLUDEPATH += $$SRC_PATH

SOURCES += main.cpp \
        $$SRC_PATH/mobilitydiagram.cpp

HEADERS += $$SRC_PATH/mobilitydiagram.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
