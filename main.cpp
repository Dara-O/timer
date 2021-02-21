/* Author: Isaac (Dara) Ogunmola
 * Started: December 18, 2020
 *
 * Description:
 * This app is a timer (stopwatch and countdown) with
 * QML UI and C++ Backend.
 *
 * Notes:
 * I tried to balance code readability and optimization.
 *
 * Bugs:
 * You can edit the time while it is counting down.
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QCoreApplication>

#include "timerinterface.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Light.otf");
    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Medium.otf");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    // Extracting the QML Objects - Control Panel and TimerFace
    QObject *rootObject = engine.rootObjects()[0];
    QObject *timerFace = rootObject->findChild<QObject*>("timerFace");
    QObject *controlPanel = rootObject->findChild<QObject*>("controlPanel");

    // Passing these objects to timerInterface.
    TimerInterface timerIterface(timerFace, controlPanel, rootObject);


    return app.exec();
}
