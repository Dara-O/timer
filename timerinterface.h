#ifndef TIMERINTERFACE_H
#define TIMERINTERFACE_H

#include <QObject>
#include <QSoundEffect>

#include "timerengine.h"

class TimerInterface : public QObject
{
    Q_OBJECT
private:

    enum State{
        COUNTDOWN,
        STOPWATCH
    };

    TimerEngine m_timerEngine;
    QObject *m_timerFace;
    QObject *m_controPanel;
    QObject *m_rootObject;
    State m_state;
    QSoundEffect m_alarm;

    int m_hour;
    int m_min;
    int m_sec;

    void updateTimerFace();
    QString formatTime(int t);



public:
    explicit TimerInterface(QObject *timerFace, QObject *controPanel, QObject *rootObject, QObject *parent = nullptr);

signals:

public slots:
    void updateTime();

    void startTimer();
    void pauseTimer();
    void continueTimer();
    void resetTimer();

    void stopwatchState();
    void countdownState();

    void setCountdownTime(QString h, QString m, QString s);

};

#endif // TIMERINTERFACE_H
