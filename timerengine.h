#ifndef TIMERENGINE_H
#define TIMERENGINE_H

#include <QObject>
#include <QTimer>

class TimerEngine : public QObject
{
    Q_OBJECT

private:
    QTimer* m_timer = nullptr;
public:
    explicit TimerEngine(QObject *parent = nullptr);
    ~TimerEngine();

signals:
    void tick();

public:
    void start();
    void stop();

};

#endif // TIMERENGINE_H
