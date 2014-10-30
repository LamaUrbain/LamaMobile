#include "testquadtree.h"
#include "quadtree.h"

static TestQuadtree *instance = NULL;
static const QString testTreeStructureExpected =
    " 0 contains 0 objects and 4 nodes.\n"
    "    1 contains 9 objects and 4 nodes.\n"
    "    QRectF(0,20 10x10)\n"
    "    QRectF(10,20 10x10)\n"
    "    QRectF(20,0 10x10)\n"
    "    QRectF(20,10 10x10)\n"
    "    QRectF(20,20 10x10)\n"
    "    QRectF(20,30 10x10)\n"
    "    QRectF(20,40 10x10)\n"
    "    QRectF(30,20 10x10)\n"
    "    QRectF(40,20 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(0,10 10x10)\n"
    "       QRectF(10,0 10x10)\n"
    "       QRectF(10,10 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(0,0 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(0,30 10x10)\n"
    "       QRectF(10,30 10x10)\n"
    "       QRectF(10,40 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(0,40 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(30,0 10x10)\n"
    "       QRectF(30,10 10x10)\n"
    "       QRectF(40,10 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(40,0 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(30,30 10x10)\n"
    "       QRectF(30,40 10x10)\n"
    "       QRectF(40,30 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(40,40 10x10)\n"
    "    1 contains 9 objects and 4 nodes.\n"
    "    QRectF(0,70 10x10)\n"
    "    QRectF(10,70 10x10)\n"
    "    QRectF(20,50 10x10)\n"
    "    QRectF(20,60 10x10)\n"
    "    QRectF(20,70 10x10)\n"
    "    QRectF(20,80 10x10)\n"
    "    QRectF(20,90 10x10)\n"
    "    QRectF(30,70 10x10)\n"
    "    QRectF(40,70 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(0,60 10x10)\n"
    "       QRectF(10,50 10x10)\n"
    "       QRectF(10,60 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(0,50 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(0,80 10x10)\n"
    "       QRectF(10,80 10x10)\n"
    "       QRectF(10,90 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(0,90 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(30,50 10x10)\n"
    "       QRectF(30,60 10x10)\n"
    "       QRectF(40,60 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(40,50 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(30,80 10x10)\n"
    "       QRectF(30,90 10x10)\n"
    "       QRectF(40,80 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(40,90 10x10)\n"
    "    1 contains 9 objects and 4 nodes.\n"
    "    QRectF(50,20 10x10)\n"
    "    QRectF(60,20 10x10)\n"
    "    QRectF(70,0 10x10)\n"
    "    QRectF(70,10 10x10)\n"
    "    QRectF(70,20 10x10)\n"
    "    QRectF(70,30 10x10)\n"
    "    QRectF(70,40 10x10)\n"
    "    QRectF(80,20 10x10)\n"
    "    QRectF(90,20 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(50,10 10x10)\n"
    "       QRectF(60,0 10x10)\n"
    "       QRectF(60,10 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(50,0 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(50,30 10x10)\n"
    "       QRectF(60,30 10x10)\n"
    "       QRectF(60,40 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(50,40 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(80,0 10x10)\n"
    "       QRectF(80,10 10x10)\n"
    "       QRectF(90,10 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(90,0 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(80,30 10x10)\n"
    "       QRectF(80,40 10x10)\n"
    "       QRectF(90,30 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(90,40 10x10)\n"
    "    1 contains 9 objects and 4 nodes.\n"
    "    QRectF(50,70 10x10)\n"
    "    QRectF(60,70 10x10)\n"
    "    QRectF(70,50 10x10)\n"
    "    QRectF(70,60 10x10)\n"
    "    QRectF(70,70 10x10)\n"
    "    QRectF(70,80 10x10)\n"
    "    QRectF(70,90 10x10)\n"
    "    QRectF(80,70 10x10)\n"
    "    QRectF(90,70 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(50,60 10x10)\n"
    "       QRectF(60,50 10x10)\n"
    "       QRectF(60,60 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(50,50 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(50,80 10x10)\n"
    "       QRectF(60,80 10x10)\n"
    "       QRectF(60,90 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(50,90 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(80,50 10x10)\n"
    "       QRectF(80,60 10x10)\n"
    "       QRectF(90,60 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(90,50 10x10)\n"
    "       2 contains 3 objects and 4 nodes.\n"
    "       QRectF(80,80 10x10)\n"
    "       QRectF(80,90 10x10)\n"
    "       QRectF(90,80 10x10)\n"
    "          3 contains 1 objects and 4 nodes.\n"
    "          QRectF(90,90 10x10)\n";

TestQuadtree::TestQuadtree()
{
    instance = this;
}

TestQuadtree::~TestQuadtree()
{
    instance = NULL;
}

void TestQuadtree::testCapacity()
{
    Quadtree<QString> tree(QRectF(0, 0, 100, 100));

    // Le quadtree doit être vide
    QVERIFY(tree.isEmpty());

    tree.insert(QRectF(10, 2, 10, 10), QString("10:2"));

    // Le quadtree doit contenir un node
    QVERIFY(!tree.isEmpty());
    QVERIFY(tree.count() == 1);

    tree.clear();

    // Le quadtree doit être vide
    QVERIFY(tree.isEmpty());
}

void TestQuadtree::testInsertInteger()
{
    Quadtree<QString> tree(QRectF(0, 0, 100, 100));

    // Le quadtree doit être vide
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
            tree.insert(QRectF(i, j, 10, 10), QString("%1:%2").arg(i).arg(j));

    QList<QuadtreeObject<QString> *> contents = tree.contents();

    // Le quadtree doit contenir 100 éléments
    QVERIFY(contents.size() == 100);

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
        {
            bool found = false;
            QString searched = QString::number(i) + ":" + QString::number(j);

            for (QList<QuadtreeObject<QString> *>::const_iterator it = contents.begin();
                 !found && it != contents.end(); ++it)
            {
                QuadtreeObject<QString> *obj = *it;

                // Le quadtree doit contenir uniquement des éléments valides
                QVERIFY(obj);

                if (obj->object == searched)
                    found = true;
            }

            // L'élément précédemment inséré doit être retrouvé
            QVERIFY(found);
        }
}

void TestQuadtree::testInsertFloat()
{
    Quadtree<QString> tree(QRectF(0, 0, 1, 1));

    // Le quadtree doit être vide
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
            tree.insert(QRectF(i / 100.0f, j / 100.0f, 0.1f, 0.1f), QString("%1:%2").arg(i).arg(j));

    QList<QuadtreeObject<QString> *> contents = tree.contents();

    // Le quadtree doit contenir 100 éléments
    QVERIFY(contents.size() == 100);

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
        {
            bool found = false;
            QString searched = QString::number(i) + ":" + QString::number(j);

            for (QList<QuadtreeObject<QString> *>::const_iterator it = contents.begin();
                 !found && it != contents.end(); ++it)
            {
                QuadtreeObject<QString> *obj = *it;

                // Le quadtree doit contenir uniquement des éléments valide
                QVERIFY(obj);

                if (obj->object == searched)
                    found = true;
            }

            // L'élément précédemment inséré doit être retrouvé
            QVERIFY(found);
        }
}

void TestQuadtree::testInsertLarge()
{
    Quadtree<int> tree(QRectF(0, 0, 1200, 1200));

    // Le quadtree doit être vide
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; ++i)
        for (int j = 0; j < 100; ++j)
            tree.insert(QRectF(i, j, 10, 10), 0);

    QList<QuadtreeObject<int> *> contents = tree.contents();

    // Le quadtree doit contenir 10.000 d'éléments
    QVERIFY(contents.size() == 10000);
}

void TestQuadtree::testQueryInteger()
{
    Quadtree<QString> tree(QRectF(0, 0, 100, 100));

    // Vérification de la taille et de l'absence de contenu
    QVERIFY(tree.bounds() == QRectF(0, 0, 100, 100));
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
            tree.insert(QRectF(i, j, 10, 10), QString("%1:%2").arg(i).arg(j));

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
        {
            QList<QuadtreeObject<QString> *> out = tree.query(QRectF(i + 1, j + 1, 1, 1));

            // La recherche ne doit donner qu'un seul élément précis
            QVERIFY(out.size() == 1);
            QVERIFY(out.first()->object == QString("%1:%2").arg(i).arg(j));
        }

    QList<QuadtreeObject<QString> *> results = tree.query(QRectF(0, 0, 100, 100));

    // Une query globale doit retourner tous les éléments
    QVERIFY(results.size() == 100);
}

void TestQuadtree::testQueryFloat()
{
    Quadtree<QString> tree(QRectF(0, 0, 1, 1));

    // Vérification de la taille et de l'absence de contenu
    QVERIFY(tree.bounds() == QRectF(0, 0, 1, 1));
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
            tree.insert(QRectF(i / 100.0f, j / 100.0f, 0.1f, 0.1f), QString("%1:%2").arg(i).arg(j));

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
        {
            QList<QuadtreeObject<QString> *> out = tree.query(QRectF(i / 100.0f + 0.001f, j / 100.0f + 0.001f, 0.09f, 0.09f));

            // La recherche ne doit donner qu'un seul élément précis
            QVERIFY(out.size() == 1);
            QVERIFY(out.first()->object == QString("%1:%2").arg(i).arg(j));
        }

    QList<QuadtreeObject<QString> *> results = tree.query(QRectF(0, 0, 100, 100));

    // Une query globale doit retourner tous les éléments
    QVERIFY(results.size() == 100);
}

void _testPrintHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);

    switch (type)
    {
        case QtDebugMsg:
            instance->_testTreeStructureBuffer += msg + "\n";
            break;
        default:
            break;
    }
}

void TestQuadtree::testTreeStructure()
{
    // Réinitialisation du test
    _testTreeStructureBuffer.clear();

    // Interception des qDebug()
    qInstallMessageHandler(_testPrintHandler);

    Quadtree<QString> tree(QRectF(0, 0, 100, 100));

    // Vérification de la taille et de l'absence de contenu
    QVERIFY(tree.bounds() == QRectF(0, 0, 100, 100));
    QVERIFY(tree.isEmpty());

    for (int i = 0; i < 100; i += 10)
        for (int j = 0; j < 100; j += 10)
            tree.insert(QRectF(i, j, 10, 10), QString("%1:%2").arg(i).arg(j));

    tree.print();

    // Arrêt de l'interception
    qInstallMessageHandler(0);

    // Vérification de l'arborescence
    QVERIFY(_testTreeStructureBuffer == testTreeStructureExpected);
}

QTEST_MAIN(TestQuadtree)
