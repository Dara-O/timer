#include "timerengine.h"

TimerEngine::TimerEngine(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer();
    m_timer->setTimerType(Qt::PreciseTimer);

    QObject::connect(m_timer, SIGNAL(timeout()), this, SIGNAL(tick()));

}

TimerEngine::~TimerEngine()
{
    delete m_timer;
}

void TimerEngine::start()
{
    m_timer->start(1000);
}

void TimerEngine::stop()
{
    m_timer->stop();
}
