#ifndef TESTQUADTREE_H
#define TESTQUADTREE_H

#include <QtTest>

class TestQuadtree : public QObject
{
    Q_OBJECT

public:
    TestQuadtree();
    virtual ~TestQuadtree();

private slots:
    void testCapacity();
    void testInsertInteger();
    void testInsertFloat();
    void testInsertLarge();
    void testRemove();
    void testRemoveAll();
    void testQueryInteger();
    void testQueryFloat();
    void testTreeStructure();

public:
    QString _testTreeStructureBuffer;
};

#endif
