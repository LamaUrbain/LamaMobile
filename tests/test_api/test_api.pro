SRC_PATH = ../../src

QT += qml network testlib
QT -= gui
TEMPLATE = app

INCLUDEPATH += $$SRC_PATH

CONFIG += c++11

SOURCES += testapi.cpp \
    $$SRC_PATH/servicesbase.cpp \
    $$SRC_PATH/itineraryservices.cpp \
    $$SRC_PATH/userservices.cpp \
    $$SRC_PATH/eventservices.cpp

HEADERS += testapi.h \
    $$SRC_PATH/servicesbase.h \
    $$SRC_PATH/itineraryservices.h \
    $$SRC_PATH/userservices.h \
    $$SRC_PATH/eventservices.h
