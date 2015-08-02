#include <QJsonDocument>
#include <QJsonObject>
#include "testapi.h"

UserSession::UserSession(TestWaiter &waiter, UserServices &userServices)
    : _waiter(waiter), _userServices(userServices)
{
    _userServices.createUser("testUser", "testPassword", "test@test.fr", [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qPrintable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qPrintable(jsonStr));

        _waiter.emitDone();
    });

    _waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qPrintable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qPrintable(jsonStr));

        _waiter.emitDone();
    });

    _waiter.waitForDone();
}

UserSession::~UserSession()
{
    _userServices.deleteUser("testUser", [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        _waiter.emitDone();
    });

    _waiter.waitForDone();

    _userServices.deleteToken([this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        _waiter.emitDone();
    });

    _waiter.waitForDone();
}

TestWaiter::TestWaiter()
{
}

void TestWaiter::emitDone()
{
    emit done();
}

void TestWaiter::waitForDone(int timeout)
{
    QSignalSpy spy(this, SIGNAL(done()));
    QVERIFY(spy.wait(timeout));
}

TestApi::TestApi()
{
}

TestApi::~TestApi()
{
}

// Users

void TestApi::testCreateUser()
{
    TestWaiter waiter;

    _userServices.createUser("testUser", "testPassword", "test@test.fr", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qPrintable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qPrintable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testGetUser()
{
}

void TestApi::testGetUsers()
{
}

void TestApi::testEditUser()
{
}

// Itineraries without auth

void TestApi::testNoAuthCreateItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthGetItineraries()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItineraries("testItinerary", "", "false", "name", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toLatin1()).array();

        QVERIFY2(array.size() > 0, qPrintable(QString("%1 : [%2]").arg(array.size()).arg(jsonStr)));

        if (array.size() > 0)
        {
            QJsonObject obj = array.first().toObject();
            QVERIFY2(obj.value("name").toString() == "testItinerary", qPrintable(jsonStr));
        }

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthGetItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItinerary(itineraryId, [&waiter, itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("id").toInt(-1) == itineraryId, qPrintable(jsonStr));
        QVERIFY2(obj.value("name").toString() == "testItinerary", qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthEditItinerary()
{
}

void TestApi::testNoAuthDestinations()
{
}

// Itineraries with auth

void TestApi::testAuthCreateItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    UserSession session(waiter, _userServices);
    Q_UNUSED(session);

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testAuthGetItineraries()
{
    int itineraryId = -1;
    TestWaiter waiter;

    UserSession session(waiter, _userServices);
    Q_UNUSED(session);

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItineraries("testItinerary", "testUser", "false", "name", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toLatin1()).array();

        QVERIFY2(array.size() > 0, qPrintable(QString("%1 : [%2]").arg(array.size()).arg(jsonStr)));

        if (array.size() > 0)
        {
            QJsonObject obj = array.first().toObject();
            QVERIFY2(obj.value("owner").toString() == "testUser", qPrintable(jsonStr));
            QVERIFY2(obj.value("name").toString() == "testItinerary", qPrintable(jsonStr));
        }

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testAuthGetItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    UserSession session(waiter, _userServices);
    Q_UNUSED(session);

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qPrintable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItinerary(itineraryId, [&waiter, itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("id").toInt(-1) == itineraryId, qPrintable(jsonStr));
        QVERIFY2(obj.value("name").toString() == "testItinerary", qPrintable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qPrintable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testAuthEditItinerary()
{
}

void TestApi::testAuthDestinations()
{
}

QTEST_MAIN(TestApi)
