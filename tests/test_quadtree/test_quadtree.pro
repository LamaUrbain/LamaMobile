SRC_PATH = ../../src

QT += testlib
QT -= gui
TEMPLATE = app

INCLUDEPATH += $$SRC_PATH

SOURCES += testquadtree.cpp

HEADERS += testquadtree.h \
    $$SRC_PATH/quadtree.h
