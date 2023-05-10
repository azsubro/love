void EventDispatcherEPoll::reinstall()
{
    delete d_ptr;
    d_ptr = new EventDispatcherEPollPrivate(this);
    d_ptr->createEpoll();
}

bool EventDispatcherEPoll::processEvents(QEventLoop::ProcessEventsFlags flags)
{
    Q_D(EventDispatcherEPoll);
    return d->processEvents(flags);
}

void EventDispatcherEPoll::registerSocketNotifier(QSocketNotifier *notifier)
{
#ifndef QT_NO_DEBUG
    if (notifier->socket() < 0) {
        qWarning("QSocketNotifier: Internal error: sockfd < 0");
        return;
    }

    if (notifier->thread() != thread() || thread() != QThread::currentThread()) {
        qWarning("QSocketNotifier: socket notifiers cannot be enabled from another thread");
        return;
    }
#endif

    Q_D(EventDispatcherEPoll);
    d->registerSocketNotifier(notifier);
}

void EventDispatcherEPoll::unregisterSocketNotifier(QSocketNotifier *notifier)
{
#ifndef QT_NO_DEBUG
    if (notifier->socket() < 0) {
        qWarning("QSocketNotifier: Internal error: sockfd < 0");
        return;
    }

    if (notifier->thread() != thread() || thread() != QThread::currentThread()) {
        qWarning("QSocketNotifier: socket notifiers cannot be disabled from another thread");
        return;
    }
#endif

    Q_D(EventDispatcherEPoll);
    d->unregisterSocketNotifier(notifier);
}

bool EventDispatcherEPoll::unregisterTimer(int timerId)
{
#ifndef QT_NO_DEBUG
    if (timerId < 1) {
        qWarning("%s: invalid arguments", Q_FUNC_INFO);
        return false;
    }

    if (thread() != QThread::currentThread()) {
        qWarning("%s: timers cannot be stopped from another thread", Q_FUNC_INFO);
        return false;
    }
#endif

    Q_D(EventDispatcherEPoll);
    return d->unregisterTimer(timerId);
}

bool EventDispatcherEPoll::unregisterTimers(QObject *object)
{
#ifndef QT_NO_DEBUG
    if (!object) {
        qWarning("%s: invalid arguments", Q_FUNC_INFO);
        return false;
    }

    if (object->thread() != thread() && thread() != QThread::currentThread()) {
        qWarning("%s: timers cannot be stopped from another thread", Q_FUNC_INFO);
        return false;
    }
#endif

    Q_D(EventDispatcherEPoll);
    return d->unregisterTimers(object);
}
