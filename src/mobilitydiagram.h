#ifndef MOBILITYDIAGRAM_H
#define MOBILITYDIAGRAM_H

#include <QQuickPaintedItem>
#define CURSOR_LEN          (10)
#define DRAGBAND_LEN        (10)
#define ATOQ(D_ANG)         ((D_ANG) * 16.)                 // For some reason QT angles are 1/16 degree
#define ATOP(PERCENT)       (((PERCENT) * 100.) / 360.)
#define PI                  (3.14159265359)
#define PI2                 (PI / 2)

//#define MOVE_MODE_SMASHALL

class MobilityDiagram : public QQuickPaintedItem
{
    Q_OBJECT

public:
    Q_ENUMS(MobilityMean)
    enum    MobilityMean
    {
        ONFOOT = 0,
        BIKE,
        VEHICLE,
        BUS,
        TRAMWAY,
        TRAIN
    };

    MobilityDiagram(QQuickPaintedItem *parent = NULL);
    ~MobilityDiagram();

    void                                setSizes(int widthNheight);
    void                                setProportion(MobilityMean mean, double degrees);
    void                                setColors(QMap<MobilityMean, QColor> const &newColors);
    QMap<MobilityMean, double>          getPercents() const;

public slots:
    void                                rearrangeDiagram();
    void                                resetDiagram();
    void                                setMeanUsage(MobilityMean mean, bool isUsed);

protected:
    virtual void    paint(QPainter *painter);

    virtual void    mousePressEvent(QMouseEvent *event);
    virtual void    mouseMoveEvent(QMouseEvent *event);
    virtual void    mouseReleaseEvent(QMouseEvent *event);
    virtual void    geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private:
    bool                            _isPointInDiagram(const QPoint &point);
    bool                            _isMeanUsed(MobilityMean mean);
    unsigned int                    _getCurrentMeanCount() const;

    bool                            _isDraging;
    MobilityMean                    _dragedMean;
    QPoint                          _previousPoint;
    QPoint                          _currentPoint;

    QRect                           _dimension;
    QMap<MobilityMean, QColor>      _meanColors;
    QMap<MobilityMean, double>      _proportions;
    QMap<MobilityMean, bool>        _selectedMeans;
};

#endif // MOBILITYDIAGRAM_H
