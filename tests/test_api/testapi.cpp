#include <QJsonDocument>
#include <QJsonObject>
#include "testapi.h"

UserSession::UserSession(TestWaiter &waiter, UserServices &userServices)
    : _waiter(waiter), _userServices(userServices)
{
    _userServices.createUser("testUser", "testPassword", "test@test.fr", false, [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        _waiter.emitDone();
    });

    _waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        _waiter.emitDone();
    });

    _waiter.waitForDone();
}

UserSession::~UserSession()
{
    _userServices.deleteUser("testUser", [this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        _waiter.emitDone();
    });

    _waiter.waitForDone();

    _userServices.deleteToken([this] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
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

ServicesBase::CallbackType TestApi::_getBasicCallBack(TestWaiter &waiter)
{
    return (ServicesBase::CallbackType([&waiter] (int errorType, QString jsonStr) mutable
      {
          QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
          waiter.emitDone();
      }));
}

// Users

void TestApi::testCreateUser()
{
    TestWaiter waiter;

    _userServices.createUser("testUser", "testPassword", "test@test.fr", false, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
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

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "48.832672, 2.288375", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 1, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthGetItineraries()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItineraries("testItinerary", "", "false", "name", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toUtf8()).array();

        QVERIFY2(array.size() > 0, qUtf8Printable(QString("%1 : [%2]").arg(array.size()).arg(jsonStr)));

        if (array.size() > 0)
        {
            QJsonObject obj = array.first().toObject();
            QVERIFY2(obj.value("name").toString() == "testItinerary", qUtf8Printable(jsonStr));
        }

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthGetItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItinerary(itineraryId, [&waiter, itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("id").toInt(-1) == itineraryId, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("name").toString() == "testItinerary", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testNoAuthEditItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    // Epitech
    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    // Append "Porte de Versailles"
    _itineraryServices.addDestination(itineraryId, "48.832672, 2.288375", "", -1, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 1, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    // Add "Porte d'Orléans" between Epitech and "Porte de Versailles"
    _itineraryServices.addDestination(itineraryId, "48.823040, 2.325578", "", 0, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 2, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.823040), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.325578), qUtf8Printable(jsonStr));

            ++it;
            if (it != destinations.constEnd())
            {
                QJsonObject obj2 = (*it).toObject();
                QVERIFY2(qFuzzyCompare(obj2.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
                QVERIFY2(qFuzzyCompare(obj2.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
            }
            else
                QVERIFY2(false, qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    // Remove "Porte de Versailles"
    _itineraryServices.deleteDestination(itineraryId, 1, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 1, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.823040), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.325578), qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    // Append "Porte de Versailles"
    _itineraryServices.addDestination(itineraryId, "48.832672, 2.288375", "", -1, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 2, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.823040), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.325578), qUtf8Printable(jsonStr));

            ++it;
            if (it != destinations.constEnd())
            {
                QJsonObject obj2 = (*it).toObject();
                QVERIFY2(qFuzzyCompare(obj2.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
                QVERIFY2(qFuzzyCompare(obj2.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
            }
            else
                QVERIFY2(false, qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    // Remove "Porte d'Orléans"
    _itineraryServices.deleteDestination(itineraryId, 0, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 1, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    // Remove "Porte de Versailles"
    _itineraryServices.deleteDestination(itineraryId, 0, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 0, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
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

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
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

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItineraries("testItinerary", "testUser", "false", "name", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toUtf8()).array();

        QVERIFY2(array.size() > 0, qUtf8Printable(QString("%1 : [%2]").arg(array.size()).arg(jsonStr)));

        if (array.size() > 0)
        {
            QJsonObject obj = array.first().toObject();
            QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
            QVERIFY2(obj.value("name").toString() == "testItinerary", qUtf8Printable(jsonStr));
        }

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
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

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItinerary(itineraryId, [&waiter, itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("id").toInt(-1) == itineraryId, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("name").toString() == "testItinerary", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

// TODO: try to edit another user's itinerary (should fail)
void TestApi::testAuthEditItinerary()
{
    int itineraryId = -1;
    TestWaiter waiter;

    UserSession session(waiter, _userServices);
    Q_UNUSED(session);

    // Epitech
    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    // Append "Porte de Versailles"
    _itineraryServices.addDestination(itineraryId, "48.832672, 2.288375", "", -1, [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();
        QJsonArray destinations = obj.value("destinations").toArray();

        QVERIFY2(destinations.size() == 1, qUtf8Printable(jsonStr));

        QJsonArray::const_iterator it = destinations.begin();

        if (it != destinations.constEnd())
        {
            QJsonObject obj = (*it).toObject();
            QVERIFY2(qFuzzyCompare(obj.value("latitude").toDouble(), 48.832672), qUtf8Printable(jsonStr));
            QVERIFY2(qFuzzyCompare(obj.value("longitude").toDouble(), 2.288375), qUtf8Printable(jsonStr));
        }
        else
            QVERIFY2(false, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testAuthDestinations()
{
}

void TestApi::testCreateSponsor()
{
    TestWaiter waiter;

    _userServices.createUser("testUser", "testPassword", "test@test.fr", true, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testGetSponsors()
{
    TestWaiter waiter;

    _userServices.createUser("testUser1", "testPassword", "test@test.fr", true, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser1", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createUser("testUser2", "testPassword", "test@test.fr", true, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser2", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.getUsers("", "true", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toUtf8()).array();

        bool user1Found = false;
        bool user2Found = false;

        for (QJsonArray::const_iterator it = array.constBegin(); it != array.constEnd(); ++it)
        {
            QJsonObject obj = (*it).toObject();

            if (obj.value("username").toString() == "testUser1")
                user1Found = true;
            else if (obj.value("username").toString() == "testUser2")
                user2Found = true;

            if (user1Found && user2Found)
                break;
        }

        QVERIFY2(user1Found, qUtf8Printable(jsonStr));
        QVERIFY2(user2Found, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser1", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser1", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser1", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser2", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser2", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser2", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testSponsorsItineraries()
{
    int itineraryId = -1;
    TestWaiter waiter;

    _userServices.createUser("testUser", "testPassword", "test@test.fr", true, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.createToken("testUser", "testPassword", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        QVERIFY2(obj.value("owner").toString() == "testUser", qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("token").toString().size() == 32, qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.createItinerary("testItinerary", "48.815346, 2.363165", "", "", "", "", "false", [&waiter, &itineraryId] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toUtf8()).object();

        itineraryId = obj.value("id").toInt(-1);

        QVERIFY2(itineraryId >= 0, qUtf8Printable(jsonStr));
        QVERIFY2(obj.value("departure").isObject(), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("latitude").toDouble(), 48.815346), qUtf8Printable(jsonStr));
        QVERIFY2(qFuzzyCompare(obj.value("departure").toObject().value("longitude").toDouble(), 2.363165), qUtf8Printable(jsonStr));

        waiter.emitDone();
    });

    waiter.waitForDone();

    if (itineraryId < 0)
        QFAIL("Could not create a valid itinerary.");

    _itineraryServices.getItineraries("testItinerary", "", "false", "", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));

        QJsonArray array = QJsonDocument::fromJson(jsonStr.toUtf8()).array();

        QVERIFY2(array.size() > 0, qUtf8Printable(QString("%1 : [%2]").arg(array.size()).arg(jsonStr)));

        if (array.size() > 0)
        {
            QJsonObject obj = array.first().toObject();
            QVERIFY2(obj.value("name").toString() == "testItinerary", qUtf8Printable(jsonStr));
        }

        waiter.emitDone();
    });

    waiter.waitForDone();

    _itineraryServices.deleteItinerary(itineraryId, [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteUser("testUser", [&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();

    _userServices.deleteToken([&waiter] (int errorType, QString jsonStr) mutable
    {
        QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 : [%2]").arg(errorType).arg(jsonStr)));
        waiter.emitDone();
    });

    waiter.waitForDone();
}

void TestApi::testEvents()
{
    TestWaiter waiter;

    _eventServices.reportIncident("test Event 1",
                                  "2015-11-06 19:08:47", "2015-11-06 21:08:47",
                                  "48.832672, 2.288375", "",
                                  _getBasicCallBack(waiter));
    waiter.waitForDone();

    _eventServices.reportIncident("test Event 2",
                                  "2015-11-06 19:08:47", "",
                                  "48.832672, 2.288375", "",
                                  _getBasicCallBack(waiter));
    waiter.waitForDone();

    // Testing automaticaly deduction of begin date
    _eventServices.reportIncident("test Event 3",
                                  "", "",
                                  "48.832672, 2.288375", "",
                                  [&waiter] (int errorType, QString jsonStr) mutable
      {
          QVERIFY2(errorType == 0, qUtf8Printable(QString("%1 (No automatic date resolution) : [%2]").arg(errorType).arg(jsonStr)));
          waiter.emitDone();
      });
    waiter.waitForDone();

    _eventServices.getIncidentList(_getBasicCallBack(waiter));
    waiter.waitForDone();
}

QTEST_MAIN(TestApi)
