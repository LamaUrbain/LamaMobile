#include <QJsonDocument>
#include <QJsonObject>
#include "testapi.h"

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

        QJsonObject obj = QJsonDocument::fromJson(jsonStr.toLatin1()).object();

        QVERIFY2(obj.value("username").toString() == "testUser", qPrintable(jsonStr));
        QVERIFY2(obj.value("email").toString() == "test@test.fr", qPrintable(jsonStr));

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

QTEST_MAIN(TestApi)
