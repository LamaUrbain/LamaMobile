#ifndef QUADTREETESTRENDERER_H
#define QUADTREETESTRENDERER_H

#include <QQuickPaintedItem>
#include "quadtree.h"

class QuadtreeTestRenderer : public QQuickPaintedItem
{
    Q_OBJECT

public:
    QuadtreeTestRenderer(QQuickItem *parent = 0);
    virtual ~QuadtreeTestRenderer();

    void setQuadtree(Quadtree<int> *tree);
    virtual void paint(QPainter *painter);

public slots:
    void addRect(const QPoint &pos);
    void removeRect(const QPoint &pos);

private:
    void paintObjects(QPainter &painter, const QList<QuadtreeObject<int> *> &contents, const QPointF &ratio) const;
    void paintNode(QPainter &painter, const Quadtree<int> &node, const QPointF &ratio) const;

private:
    Quadtree<int> *_tree;
};

#endif // QUADTREETESTRENDERER_H
