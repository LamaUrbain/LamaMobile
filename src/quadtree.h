#ifndef QUADTREE_H
#define QUADTREE_H

#include <QRectF>
#include <QVector>
#include <QDebug>

template<typename T>
struct QuadtreeObject
{
    QuadtreeObject(const QRectF &r, const T &o);
    QuadtreeObject(const QuadtreeObject &other);
    QuadtreeObject &operator=(const QuadtreeObject &other);
    QRectF rect;
    T object;
};

template<typename T>
class Quadtree
{
public:
    Quadtree(const QRectF &bounds);
    ~Quadtree();

    void clear();
    void insert(const QRectF &rect, const T &obj);
    void insert(QuadtreeObject<T> *obj);
    QList<QuadtreeObject<T> *> query(const QRectF &rect) const;
    QList<QuadtreeObject<T> *> contents() const;
    QList<const Quadtree<T> *> nodes() const;

    const QRectF &bounds() const;
    bool isEmpty() const;
    int count() const;
    void print(int level = 0) const;

private:
    void split();

private:
    QRectF _bounds;
    QList<QuadtreeObject<T> *> _objects;
    Quadtree<T> *_nodes[4];
};

template<typename T>
QuadtreeObject<T>::QuadtreeObject(const QRectF &r, const T &o)
    : rect(r), object(o)
{
}

template<typename T>
QuadtreeObject<T>::QuadtreeObject(const QuadtreeObject &other)
    : rect(other.rect), object(other.object)
{
}

template<typename T>
QuadtreeObject<T> &QuadtreeObject<T>::operator=(const QuadtreeObject &other)
{
    rect = other.rect;
    object = other.object;
    return *this;
}

template<typename T>
Quadtree<T>::Quadtree(const QRectF &bounds)
    : _bounds(bounds)
{
    for (quint8 i = 0; i < 4; ++i)
        _nodes[i] = NULL;
}

template<typename T>
Quadtree<T>::~Quadtree()
{
    clear();
}

template<typename T>
void Quadtree<T>::clear()
{
    qDeleteAll(_objects);
    _objects.clear();

    for (quint8 i = 0; i < 4; ++i)
    {
        delete _nodes[i];
        _nodes[i] = NULL;
    }
}

template<typename T>
const QRectF &Quadtree<T>::bounds() const
{
    return _bounds;
}

template<typename T>
bool Quadtree<T>::isEmpty() const
{
    if (_bounds.isEmpty())
        return true;

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i])
            return false;

    return true;
}

template<typename T>
int Quadtree<T>::count() const
{
    int count = 0;

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i])
            count += _nodes[i]->count();

    return count + _objects.size();
}

template<typename T>
QList<QuadtreeObject<T> *> Quadtree<T>::contents() const
{
    QList<QuadtreeObject<T> *> results;

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i])
            results.append(_nodes[i]->contents());

    results.append(_objects);
    return results;
}

template<typename T>
QList<const Quadtree<T> *> Quadtree<T>::nodes() const
{
    QList<const Quadtree<T> *> results;

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i])
            results.append(_nodes[i]);

    return results;
}

template<typename T>
void Quadtree<T>::split()
{
    if ((_bounds.height() * _bounds.width()) <= static_cast<qreal>(0.0001))
        return;

    qreal halfWidth = (_bounds.width() / static_cast<qreal>(2.0));
    qreal halfHeight = (_bounds.height() / static_cast<qreal>(2.0));

    _nodes[0] = new Quadtree<T>(QRectF(_bounds.topLeft(), QSizeF(halfWidth, halfHeight)));
    _nodes[1] = new Quadtree<T>(QRectF(QPointF(_bounds.left(), _bounds.top() + halfHeight), QSizeF(halfWidth, halfHeight)));
    _nodes[2] = new Quadtree<T>(QRectF(QPointF(_bounds.left() + halfWidth, _bounds.top()), QSizeF(halfWidth, halfHeight)));
    _nodes[3] = new Quadtree<T>(QRectF(QPointF(_bounds.left() + halfWidth, _bounds.top() + halfHeight), QSizeF(halfWidth, halfHeight)));
}

template<typename T>
void Quadtree<T>::insert(const QRectF &rect, const T &obj)
{
    insert(new QuadtreeObject<T>(rect, obj));
}

template<typename T>
void Quadtree<T>::insert(QuadtreeObject<T> *obj)
{
    if (!obj)
    {
        qWarning() << "Trying to insert an invalid item";
        return;
    }

    if (!_bounds.contains(obj->rect) && !_bounds.intersects(obj->rect))
    {
        qWarning() << "Trying to insert an item that is out of the bounds of the quadtree:" << obj->rect << "out of" << _bounds;
        return;
    }

    if (_nodes[0] == NULL)
        split();

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i])
        {
            if (_nodes[i]->bounds().contains(obj->rect))
            {
                _nodes[i]->insert(obj);
                return;
            }
        }

    _objects.append(obj);
}

template<typename T>
QList<QuadtreeObject<T> *> Quadtree<T>::query(const QRectF &rect) const
{
    QList<QuadtreeObject<T> *> results;

    for (typename QList<QuadtreeObject<T> *>::const_iterator it = _objects.constBegin();
         it != _objects.constEnd(); ++it)
    {
        QuadtreeObject<T> *obj = *it;
        if (obj && rect.intersects(obj->rect))
            results.append(obj);
    }

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i] && !_nodes[i]->isEmpty())
        {
            if (_nodes[i]->bounds().contains(rect))
            {
                results.append(_nodes[i]->query(rect));
                break;
            }

            if (rect.contains(_nodes[i]->bounds()))
            {
                results.append(_nodes[i]->contents());
                continue;
            }

            if (_nodes[i]->bounds().intersects(rect))
                results.append(_nodes[i]->query(rect));
        }

    return results;
}

template<typename T>
void Quadtree<T>::print(int level) const
{
    int count = 0;
    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i] != NULL)
            ++count;

    QString space = "";
    for (int i = 0; i < level; ++i)
        space.append("   ");

    if (count > 0 || !_objects.isEmpty())
        qDebug() << qPrintable(space) << level << "contains" << _objects.size() << "objects and" << count << "nodes.";

    for (int i = 0; i < _objects.size(); ++i)
        qDebug() << qPrintable(space) << _objects.at(i)->rect;

    for (quint8 i = 0; i < 4; ++i)
        if (_nodes[i] != NULL)
            _nodes[i]->print(level + 1);
}

#endif // QUADTREE_H
