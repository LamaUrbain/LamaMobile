#ifndef TESTAPI_H
#define TESTAPI_H

#include <QtTest>

#include "userservices.h"
#include "itineraryservices.h"

class TestWaiter : public QObject
{
    Q_OBJECT

public:
    TestWaiter();

    void emitDone();
    void waitForDone(int timeout = 3000);

signals:
    void done();
};

class TestApi : public QObject
{
    Q_OBJECT

public:
    TestApi();
    virtual ~TestApi();

private slots:
    void testCreateUser();
    void testGetUser();
    void testGetUsers();
    void testEditUser();

private:
    UserServices _userServices;
    ItineraryServices _itineraryServices;
};

#endif
