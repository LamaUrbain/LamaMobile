OBJECTS_DIR = demo_mobilitydiagram_obj
MOC_DIR = demo_mobilitydiagram_moc

TEMPLATE = app
QT += qml quick
CONFIG += c++11

INCLUDEPATH += ../../src/ #Do not put $$SRCPATH or somthing, MSVC doesn't like it

SOURCES += main.cpp \
        ../../src/mobilitydiagram.cpp

HEADERS += ../../src/mobilitydiagram.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
