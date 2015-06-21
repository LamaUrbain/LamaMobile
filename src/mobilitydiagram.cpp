#include <iostream>
#include <QPainter>
#include <QMouseEvent>
#include "mobilitydiagram.h"

MobilityDiagram::MobilityDiagram(QQuickPaintedItem *parent) :
    QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::AllButtons);
    setSizes(100);

    _meanColors = QMap<MobilityMean, QColor> {
        {ONFOOT, QColor(0, 128, 255)},
        {BIKE, QColor(0, 175, 0)},
        {VEHICLE, QColor(100, 0, 255)},
        {BUS, QColor(200, 0, 0)},
        {TRAMWAY, QColor(255, 125, 0)},
        {TRAIN, QColor(100, 100, 100)}
    };

    resetDiagram();
}

MobilityDiagram::~MobilityDiagram()
{
}

void MobilityDiagram::setColors(QMap<MobilityMean, QColor> const &newColors)
{
    if (newColors.size() != static_cast<int>(_meanColors.count()))
        return;
    _meanColors = newColors;
}

void MobilityDiagram::setSizes(int widthNheight)
{
    _dimension.setWidth(widthNheight);
    _dimension.setHeight(widthNheight);
}

void MobilityDiagram::setProportion(MobilityDiagram::MobilityMean mean, double degrees)
{
#ifdef MOVE_MODE_SMASHALL
    // obselete
    double diff = _proportions.value(mean);
    degrees = qBound<double>(0., degrees, 360.);
    _proportions.insert(mean, degrees);
    diff = (diff - degrees) / (_selectedMeans.count() - 1);
    double val;
    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (it.key() != mean && _isMeanUsed(it.key()))
        {
            val = *it + diff;
            _proportions.insert(it.key(), qBound<double>(0., val, 360.));
        }
#else
    auto itb = _proportions.find(mean);
    auto it = itb;
    while (!_isMeanUsed(it.key()) || it == itb)
    {
        if (it == _proportions.begin())
            it = _proportions.end();
        it--;
        if (it == itb)
            return;
    }

    degrees = qBound<double>(0., degrees, 360.);
    double diff = _proportions.value(mean) - degrees;
    double val = *it + diff * 2;
    diff = degrees - diff;

    const int limit = 360 - (_getCurrentMeanCount() * DRAGBAND_LEN);
    if (val < DRAGBAND_LEN || val > limit
        || diff < DRAGBAND_LEN || val > limit)
        return;

    _proportions.insert(mean, diff);
    _proportions.insert(it.key(), val);
#endif
}

void MobilityDiagram::paint(QPainter *painter)
{
    if (!painter)
        return;

    double          lastVal = _proportions.first(), currentVal;
    double          qLastVal, qCurrentVal;
    const double    dragBandLen = ATOQ(DRAGBAND_LEN);

    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (_isMeanUsed(it.key()))
        {
            currentVal = *it;
            qLastVal = ATOQ(lastVal);
            qCurrentVal = ATOQ(currentVal);

            painter->setPen(Qt::transparent);
            painter->setBrush(QBrush(_meanColors.value(it.key())));
            painter->drawPie(_dimension, qLastVal, qCurrentVal);

            painter->setPen(Qt::black);
            painter->setBrush(QBrush(QColor(0, 0, 0, 100)));
            painter->drawPie(_dimension, qLastVal, dragBandLen);

            lastVal += currentVal;
        }
}

void MobilityDiagram::mousePressEvent(QMouseEvent *event)
{
    if (!event || !_isPointInDiagram(event->pos()))
        return;

    const double size = _dimension.width() / 2;
    const double x = event->pos().x() - size, y = size - event->pos().y();
    const double deg = ((atan2(y, x) * 180.0) / 3.14159265359) + 360. * (y < 0);

    double start = _proportions.first();
    double end = start + ((_proportions.first() > DRAGBAND_LEN) ? DRAGBAND_LEN : _proportions.first());
    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (_isMeanUsed(it.key()))
        {
            if (deg > start && deg < end)
            {
                _dragedMean = it.key();
                _isDraging = true;
                _currentPoint.rx() = x;
                _currentPoint.ry() = y;
                _previousPoint = _currentPoint;
                break;
            }
            start += *it;
            if (start >= 360.)
                start -= 360.;
            end = start + ((*it > DRAGBAND_LEN) ? DRAGBAND_LEN : *it);
        }
}

void MobilityDiagram::mouseMoveEvent(QMouseEvent *event)
{
    if (!event || !_isDraging || !_isPointInDiagram(event->pos()))
    {
        _isDraging = false;
        return;
    }

    const double size = _dimension.width() / 2;
    const double x = event->pos().x() - size, y = size - event->pos().y();


    double alpha;

    _previousPoint = _currentPoint;
    double X1 = _previousPoint.x();
    double Y1 = _previousPoint.y();

    _currentPoint.rx() = x;
    _currentPoint.ry() = y;

    double X2 = _currentPoint.x();
    double Y2 = _currentPoint.y();

    if (X1 == 0.0f)
        X1 = 0.001f;
    if (X2 == 0.0f)
        X2 = 0.001f;

    double alpha1 = atan(Y1 / X1);
    double alpha2 = atan(Y2 / X2);

    alpha = alpha2 - alpha1;

    if (alpha > PI2)
        alpha -= PI;
    else if (alpha < -PI2)
        alpha += PI;

    double result = _proportions.value(_dragedMean) - (alpha * 180. / PI) * (1 - 2 * (!_dragedMean));
    setProportion(_dragedMean, result);
    update();
}

void MobilityDiagram::mouseReleaseEvent(QMouseEvent *event)
{
    if (!event || !_isDraging)
        return;

    _currentPoint.rx() = 0.;
    _currentPoint.ry() = 0.;
    _previousPoint = _currentPoint;

    _isDraging = false;
}

void MobilityDiagram::geometryChanged(const QRectF &, const QRectF &)
{
    setSizes(qMin(width(), height()));
}

bool MobilityDiagram::_isPointInDiagram(const QPoint &point)
{
    const int size = _dimension.width() / 2;
    const int x = point.x() - size, y = size - point.y();

    if (pow(x, 2) + pow(y, 2) < pow(size + CURSOR_LEN * _selectedMeans.count(), 2))
        return (true);
    return (false);
}

void MobilityDiagram::setMeanUsage(MobilityDiagram::MobilityMean mean, bool checked)
{
    const int alterationSign = -1 + 2 * checked;
    _selectedMeans.insert(mean, checked);

    double arrangedSpace = ((alterationSign == -1) ? _proportions.value(mean) : 360);
    arrangedSpace /= _getCurrentMeanCount();

    const double addCurr = static_cast<double>(alterationSign == -1);
    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (_isMeanUsed(it.key()))
            _proportions.insert(it.key(), *it * addCurr + arrangedSpace);

    update();
}

bool MobilityDiagram::_isMeanUsed(MobilityDiagram::MobilityMean mean)
{
    return (_selectedMeans.value(mean));
}

unsigned int MobilityDiagram::_getCurrentMeanCount() const
{
    unsigned int count = 0;
    for (auto it = _selectedMeans.begin(); it != _selectedMeans.end(); ++it)
    {
        count += static_cast<unsigned int>(*it);
    }
    return (count);
}


void MobilityDiagram::resetDiagram()
{
    const double basePart = 360 / static_cast<double>(_meanColors.count());
    for (auto it = _meanColors.begin(); it != _meanColors.end(); ++it)
    {
        _proportions.insert(it.key(), basePart);
        _selectedMeans.insert(it.key(), true);
    }
    update();
}

QMap<MobilityDiagram::MobilityMean, double> MobilityDiagram::getPercents() const
{
    QMap<MobilityDiagram::MobilityMean, double> ret;

    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        ret.insert(it.key(), ATOP(*it));
    return (ret);
}

void MobilityDiagram::rearrangeDiagram()
{
    const double basePart = 360 / static_cast<double>(_getCurrentMeanCount());
    for (auto it = _meanColors.begin(); it != _meanColors.end(); ++it)
        if (_isMeanUsed(it.key()))
            _proportions.insert(it.key(), basePart);
    update();
}
