#ifndef MOBILITYDIAGRAM_H
#define MOBILITYDIAGRAM_H

#include <QQuickPaintedItem>

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

protected:
    virtual void    paint(QPainter *painter);

    virtual void    mousePressEvent(QMouseEvent *event);
    virtual void    mouseMoveEvent(QMouseEvent *event);
    virtual void    mouseReleaseEvent(QMouseEvent *event);
    virtual void    geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private slots:
    void            resetDiagram();
    void            on_pushButton_released();

private:
    void            _onBoxClicked(MobilityMean mean, bool checked);
    bool            _isPointInDiagram(const QPoint &point);
    bool            _isMeanUsed(MobilityMean mean);

    bool                            _isDraging;
    MobilityMean                    _dragedMean;
    QPoint                          _previousPoint;
    QPoint                          _currentPoint;

    unsigned int                    _meanCount;
    QRect                           _dimension;
    QMap<MobilityMean, QColor>      _meanColors;
    QMap<MobilityMean, double>      _proportions;
    QMap<MobilityMean, bool>        _selectedMeans;
};

#endif // MOBILITYDIAGRAM_H
