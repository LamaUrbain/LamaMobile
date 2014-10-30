#include <QTime>
#include <QPainter>
#include "quadtreetestrenderer.h"

QuadtreeTestRenderer::QuadtreeTestRenderer(QQuickItem *parent)
    : QQuickPaintedItem(parent), _tree(NULL)
{
    qsrand(QTime::currentTime().msecsSinceStartOfDay());
    setQuadtree(new Quadtree<int>(QRectF(0, 0, 100, 100)));
}

QuadtreeTestRenderer::~QuadtreeTestRenderer()
{
    delete _tree;
    _tree = NULL;
}

void QuadtreeTestRenderer::setQuadtree(Quadtree<int> *tree)
{
    _tree = tree;
    update();
}

void QuadtreeTestRenderer::addRect(const QPoint &pos)
{
    if (!_tree)
        return;

    QPointF ratio;
    ratio.setX(width() / _tree->bounds().width());
    ratio.setY(height() / _tree->bounds().height());

    int width = qMax(1, ((qrand() % 100) / 10));
    int height = qMax(1, ((qrand() % 100) / 10));

    _tree->insert(QRect(pos.x() / ratio.x(), pos.y() / ratio.y(), width, height), qrand() % 200);

    update();
}

void QuadtreeTestRenderer::paint(QPainter *painter)
{
    if (painter && _tree)
    {
        QPointF ratio;
        ratio.setX(width() / _tree->bounds().width());
        ratio.setY(height() / _tree->bounds().height());

        paintObjects(*painter, _tree->contents(), ratio);
        paintNode(*painter, *_tree, ratio);
    }
}

void QuadtreeTestRenderer::paintObjects(QPainter &painter, const QList<QuadtreeObject<int> *> &contents, const QPointF &ratio) const
{
    painter.save();

    QPen pen;
    pen.setWidth(0);
    pen.setStyle(Qt::NoPen);

    painter.setPen(pen);

    foreach (QuadtreeObject<int> *obj, contents)
    {
        painter.setBrush(QBrush(QColor::fromHsv(obj->object, 255, 190)));
        painter.drawRect(obj->rect.x() * ratio.x(), obj->rect.y() * ratio.y(), obj->rect.width() * ratio.x(), obj->rect.height() * ratio.y());
    }

    painter.restore();
}

void QuadtreeTestRenderer::paintNode(QPainter &painter, const Quadtree<int> &node, const QPointF &ratio) const
{
    QList<const Quadtree<int> *> subnodes = node.nodes();

    for (QList<const Quadtree<int> *>::const_iterator it = subnodes.constBegin();
         it != subnodes.constEnd(); ++it)
    {
        const Quadtree<int> *subnode = *it;

        if (subnode)
        {
            paintObjects(painter, subnode->contents(), ratio);
            paintNode(painter, *subnode, ratio);

            painter.save();
            painter.drawLine(subnode->bounds().x() * ratio.x(), subnode->bounds().y() * ratio.y(), subnode->bounds().x() * ratio.x() + subnode->bounds().width() * ratio.x(), subnode->bounds().y() * ratio.y());
            painter.drawLine(subnode->bounds().x() * ratio.x(), subnode->bounds().y() * ratio.y(), subnode->bounds().x() * ratio.x(), subnode->bounds().y() * ratio.y() + subnode->bounds().height() * ratio.y());
            painter.restore();
        }
    }
}
