#ifndef TESTAPI_H
#define TESTAPI_H

#include <QtTest>

#include "userservices.h"
#include "itineraryservices.h"
#include "eventservices.h"

// Used to wait for the end of a network request
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

// Used to create a session and to delete it at the end of a test
class UserSession
{
public:
    UserSession(TestWaiter &waiter, UserServices &userServices);
    ~UserSession();

private:
    TestWaiter &_waiter;
    UserServices &_userServices;
};

// Test cases
class TestApi : public QObject
{
    Q_OBJECT

public:
    TestApi();
    virtual ~TestApi();

private slots:
    // Users
    void testCreateUser();
    void testGetUser();
    void testGetUsers();
    void testEditUser();

    // Itineraries without auth
    void testNoAuthCreateItinerary();
    void testNoAuthGetItineraries();
    void testNoAuthGetItinerary();
    void testNoAuthEditItinerary();
    void testNoAuthDestinations();

    // Itineraries with auth
    void testAuthCreateItinerary();
    void testAuthGetItineraries();
    void testAuthGetItinerary();
    void testAuthEditItinerary();
    void testAuthDestinations();

    // Sponsors
    void testCreateSponsor();
    void testGetSponsors();
    void testSponsorsItineraries();

    // Events
    void testEvents();

private:
    UserServices _userServices;
    ItineraryServices _itineraryServices;
    EventServices _eventServices;

    ServicesBase::CallbackType _getBasicCallBack(TestWaiter &waiter);
};

#endif
