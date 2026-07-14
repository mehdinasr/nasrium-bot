import time

class EventStreamEngine:
    # حافظه موقت برای وقایع جهانی
    GLOBAL_EVENTS = [
        {"type": "SYSTEM", "msg": "Imperial Neural Network Online.", "time": "INIT"}
    ]

    @staticmethod
    def add_event(e_type, message):
        event = {
            "type": e_type,
            "msg": message,
            "time": time.strftime("%H:%M")
        }
        EventStreamEngine.GLOBAL_EVENTS.append(event)
        # نگهداری فقط ۱۰ رویداد آخر
        if len(EventStreamEngine.GLOBAL_EVENTS) > 10:
            EventStreamEngine.GLOBAL_EVENTS.pop(0)

    @staticmethod
    def get_stream():
        return EventStreamEngine.GLOBAL_EVENTS
