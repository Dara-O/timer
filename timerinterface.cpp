#include "timerinterface.h"
#include "QDebug"

void TimerInterface::updateTimerFace()
{
    //formatting the output text
    QString hour = formatTime(m_hour);
    QString min = formatTime(m_min);
    QString sec = formatTime(m_sec);

    QMetaObject::invokeMethod(m_timerFace, "updateTime", Q_ARG(QString, hour), Q_ARG(QString, min), Q_ARG(QString, sec));
}

QString TimerInterface::formatTime(int t)
{
    QString text = QString::number(t);

    if(text.length() < 2)
        text = "0" + text;

    return text;
}

TimerInterface::TimerInterface(QObject *timerFace, QObject *controPanel, QObject *rootObject, QObject *parent)
    : QObject(parent), m_timerFace(timerFace), m_controPanel(controPanel), m_rootObject(rootObject), m_hour(0), m_min(0), m_sec(0)
{
    //Connect to the timer Engine
    QObject::connect(&m_timerEngine, SIGNAL(tick()), this, SLOT(updateTime()));

    // Connect to QML Signals (Control Panel)
    QObject::connect(m_controPanel, SIGNAL(start()), this, SLOT(startTimer()));
    QObject::connect(m_controPanel, SIGNAL(reset()), this, SLOT(resetTimer()));
    QObject::connect(m_controPanel, SIGNAL(pause()), this, SLOT(pauseTimer()));
    QObject::connect(m_controPanel, SIGNAL(continueTimer()), this, SLOT(continueTimer()));

    // Connect TimeEdited
    QObject::connect(m_timerFace, SIGNAL(timeEdited(QString, QString, QString)), this, SLOT(setCountdownTime(QString, QString, QString)));

    //Connect the stopwatch state and countdown state to the timerinterface
    QObject::connect(m_rootObject, SIGNAL(stopwatchState()), this, SLOT(stopwatchState()));
    QObject::connect(m_rootObject, SIGNAL(countdownState()), this, SLOT(countdownState()));

    //Default State
    m_state = STOPWATCH;

    //set the alarm
    m_alarm.setSource(QUrl::fromLocalFile(":/sounds/alarm.wav"));
    m_alarm.setLoopCount(QSoundEffect::Infinite);
    m_alarm.setVolume(1);

}

void TimerInterface::updateTime()
{
    if(m_state == STOPWATCH)
    {
        ++m_sec;

        if(m_sec >= 60)
        {
            m_sec = 0;
            ++m_min;
        }

        if(m_min >= 60)
        {
            m_min = 0;
            ++m_hour;
        }
        if(m_hour > 99) //at hours reset and stop the timer
        {
            m_timerEngine.stop();
            m_hour = 0;
        }
    }

    else if(m_state == COUNTDOWN)
    {

        --m_sec;

        if(m_sec < 0)
        {
            m_sec = 59;
            --m_min;
        }

        if(m_min < 0)
        {
            m_min = 59;
            --m_hour;
        }

        if(m_hour < 0)
        {
            m_hour = 0;
        }

        if((m_hour == 0) && (m_min == 0) && (m_sec == 0))
        {
            //TODO: Play sound and disable the startButton, and stop the timer
            resetTimer();

            QMetaObject::invokeMethod(m_controPanel, "disableStart");

            m_alarm.play();

            // prevent the user from setting the time while the alarm is ringing
            QMetaObject::invokeMethod(m_timerFace, "makeUneditable");

            //Sets the start button to display "Start"
            QMetaObject::invokeMethod(m_controPanel, "resetControlPanel");
        }
    }

    updateTimerFace();
}

void TimerInterface::startTimer()
{
    if(m_state == STOPWATCH)
        resetTimer();

    // if state is countdown, and the timer has be started, make the timerface uneditable
    if(m_state == COUNTDOWN)
        QMetaObject::invokeMethod(m_timerFace, "makeUneditable");

    m_timerEngine.start();
}

void TimerInterface::pauseTimer()
{
    // make the timerface editable when the timer has been paused
    if(m_state == COUNTDOWN)
        QMetaObject::invokeMethod(m_timerFace, "makeEditable");
    m_timerEngine.stop();
}

void TimerInterface::continueTimer()
{
    // if state is countdown, and the timer has be started, make the timerface uneditable
    if(m_state == COUNTDOWN)
        QMetaObject::invokeMethod(m_timerFace, "makeUneditable");


    m_timerEngine.start();
}

void TimerInterface::resetTimer()
{
    pauseTimer();

    m_hour = 0;
    m_min = 0;
    m_sec = 0;

    //During CountDown reset stops the sound (if 00:00:00), otherwise sets 00:00:00 and disables the startbutton

    if(m_alarm.isPlaying()) //if sound is playing
        m_alarm.stop(); //stop sound

    if(m_state == COUNTDOWN)
    {

        //disable the start button.
        QMetaObject::invokeMethod(m_controPanel, "disableStart");
    }


    updateTimerFace();
}

void TimerInterface::stopwatchState()
{
    m_state = STOPWATCH;

    //TODO: other things and enable the startButton
    resetTimer();
    QMetaObject::invokeMethod(m_controPanel, "enableStart");

    //Sets the start button to display "Start"
    QMetaObject::invokeMethod(m_controPanel, "resetControlPanel");
}

void TimerInterface::countdownState()
{
    m_state = COUNTDOWN;

    //TODO: Other things
    resetTimer();

    //Sets the start button to display "Start"
    QMetaObject::invokeMethod(m_controPanel, "resetControlPanel");
}

void TimerInterface::setCountdownTime(QString h, QString m, QString s)
{
    if(m_state == COUNTDOWN)
    {
        m_hour = h.toInt();
        m_min = m.toInt();
        m_sec = s.toInt();


        //Enable the start Button if the times meet certain criteria
        bool allZeros = (m_hour != 0) || (m_min != 0) || (m_sec != 0);
        bool allLegalTimes = ((m_min < 60) && (m_sec < 60)) && ((m_sec >= 0) && (m_min >= 0) && (m_hour >= 0));

        if(allZeros && allLegalTimes)
            QMetaObject::invokeMethod(m_controPanel, "enableStart");
        else
            QMetaObject::invokeMethod(m_controPanel, "disableStart");
    }

}
