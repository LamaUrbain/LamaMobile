#include <iostream>
#include <QPainter>
#include <QMouseEvent>
#include "mobilitydiagram.h"

#define CURSOR_LEN          (10)
#define DRAGBAND_LEN        (5)
#define ATOQ(D_ANG)         ((D_ANG) * 16.)                 // For some reason QT angles are 1/16 degree
#define ATOP(PERCENT)       (((PERCENT) * 100.) / 360.)
#define PI                  (3.14159265359)
#define PI2                 (PI / 2)

#define MOVE_MODE_SMASHALL

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

    _meanCount = _meanColors.size();
    for (auto it = _meanColors.begin(); it != _meanColors.end(); ++it)
    {
        _proportions.insert(it.key(), 360. / static_cast<double>(_meanCount));
        _selectedMeans.insert(it.key(), true);
    }
}

MobilityDiagram::~MobilityDiagram()
{
}

void MobilityDiagram::setColors(QMap<MobilityMean, QColor> const &newColors)
{
    if (newColors.size() != _meanCount)
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
    double diff = _proportions.value(mean);
    degrees = qBound<double>(0., degrees, 360.);
    _proportions.insert(mean, degrees);
    diff = (diff - degrees) / (_meanCount - 1);
    double val;
    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (it.key() != mean && _isMeanUsed(it.key()))
        {
            val = *it + diff;
            _proportions.insert(it.key(), qBound<double>(0., val, 360.));
        }
#else
    double diff = _proportions.value(mean);
    degrees = qBound<double>(0., degrees, 360.);
    diff = (diff - degrees);
    double val;
    auto it = _proportions.find(mean);
    if (it == _proportions.end())
        it = _proportions.begin();
    it++;
    val = *it + diff;
    _proportions.insert(mean, qBound<double>(0., degrees, 360.));
    _proportions.insert(it.key(), qBound<double>(0., val, 360.));
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

bool MobilityDiagram::_isPointInDiagram(QPoint &point)
{
    const int size = _dimension.width() / 2;
    const int x = point.x() - size, y = size - point.y();

    if (pow(x, 2) + pow(y, 2) < pow(size + CURSOR_LEN * _meanCount, 2))
        return (true);
    return (false);
}

void MobilityDiagram::_onBoxClicked(MobilityDiagram::MobilityMean mean, bool checked)
{
    const int alterationSign = -1 + 2 * checked;
    _selectedMeans.insert(mean, checked);
    _meanCount += alterationSign;
    auto alteredSpace = (_proportions.value(mean) / _meanCount) * -alterationSign;
    for (auto it = _proportions.begin(); it != _proportions.end(); ++it)
        if (_isMeanUsed(it.key()))
            _proportions.insert(it.key(), *it + alteredSpace);
    update();
}

bool MobilityDiagram::_isMeanUsed(MobilityDiagram::MobilityMean mean)
{
    return (_selectedMeans.value(mean));
}


void MobilityDiagram::resetDiagram()
{
    for (auto it = _meanColors.begin(); it != _meanColors.end(); ++it)
    {
        _proportions.insert(it.key(), 360. / static_cast<double>(_meanCount));
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

void MobilityDiagram::on_pushButton_released()
{
    resetDiagram();
}
