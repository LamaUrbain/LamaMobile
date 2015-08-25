#ifndef USERSERVICES_H
#define USERSERVICES_H

#include <QObject>
#include "servicesbase.h"


class UserServices : public ServicesBase
{
    Q_OBJECT


public:
    UserServices();
    virtual ~UserServices();
    static UserServices *getInstance();
    static const QString &getToken();


    void getUsers(QString search, ServicesBase::CallbackType callback);
    void getUser(QString username, ServicesBase::CallbackType callback);
    void createUser(QString username, QString password, QString email, ServicesBase::CallbackType callback);
    void editUser(QString username, QString password, QString email, ServicesBase::CallbackType callback);
    void deleteUser(QString username, ServicesBase::CallbackType callback);
    void createToken(QString username, QString password, ServicesBase::CallbackType callback);
    void deleteToken(ServicesBase::CallbackType callback);


public slots:
    void getUsers(QString search, QJSValue callback);
    void getUser(QString username, QJSValue callback);
    void createUser(QString username, QString password, QString email, QJSValue callback);
    void editUser(QString username, QString password, QString email, QJSValue callback);
    void deleteUser(QString username, QJSValue callback);
    void createToken(QString username, QString password, QJSValue callback);
    void deleteToken(QJSValue callback);


private:
    static UserServices *_instance;
    QString _token;
};


#endif // USERSERVICES_H
