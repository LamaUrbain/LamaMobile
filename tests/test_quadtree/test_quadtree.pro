SRC_PATH = ../../src

QT += testlib
TEMPLATE = app

INCLUDEPATH += $$SRC_PATH

SOURCES += testquadtree.cpp

HEADERS += testquadtree.h \
    $$SRC_PATH/quadtree.h
