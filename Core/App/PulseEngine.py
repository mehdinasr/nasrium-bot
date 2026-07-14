import time

class PulseEngine:
    @staticmethod
    def log_event(db, event_type, message):
        # ثبت واقعه در جریان عمومی جهان
        pulse_entry = {
            "type": event_type, # raid, upgrade, join, mint
            "message": message,
            "timestamp": time.time()
        }
        db.world_pulse.insert_one(pulse_entry)
        
        # محدودسازی به 20 واقعه آخر برای بهینگی
        count = db.world_pulse.count_documents({})
        if count > 20:
            oldest = list(db.world_pulse.find().sort("timestamp", 1).limit(count - 20))
            for doc in oldest:
                db.world_pulse.delete_one({"_id": doc["_id"]})
        return True

    @staticmethod
    def get_recent_pulse(db):
        events = list(db.world_pulse.find().sort("timestamp", -1).limit(10))
        for e in events: e['_id'] = str(e['_id'])
        return events
