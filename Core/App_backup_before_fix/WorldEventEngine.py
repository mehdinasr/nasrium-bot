import random
import time

class WorldEventEngine:
    EVENTS = {
        "none": {"label": "Peaceful Skies", "desc": "No global effects active.", "multiplier": 1.0, "color": "#00f3ff"},
        "gold_rush": {"label": "GOLD RUSH", "desc": "2x Extraction Speed!", "multiplier": 2.0, "color": "#ffd700"},
        "cyber_storm": {"label": "CYBER STORM", "desc": "Defense systems overloaded (+50% DEF)", "multiplier": 1.5, "color": "#ff003c"},
        "military_parade": {"label": "MILITARY PARADE", "desc": "Troop training is 50% cheaper", "multiplier": 0.5, "color": "#bc00ff"}
    }

    @staticmethod
    def get_current_event():
        # در نسخه پیشرفته، این از دیتابیس خوانده می‌شود که هر چند ساعت تغییر می‌کند
        # فعلاً برای دمو، بر اساس ساعت فعلی یک واقعه را انتخاب می‌کنیم
        hour = time.localtime().tm_hour
        if hour % 4 == 0: return "gold_rush"
        if hour % 4 == 1: return "cyber_storm"
        if hour % 4 == 2: return "military_parade"
        return "none"

    @staticmethod
    def apply_event_modifier(base_value, event_id, target_type):
        event = WorldEventEngine.EVENTS.get(event_id, WorldEventEngine.EVENTS["none"])
        
        if event_id == "gold_rush" and target_type == "gold":
            return int(base_value * event["multiplier"])
        if event_id == "cyber_storm" and target_type == "def":
            return int(base_value * event["multiplier"])
        if event_id == "military_parade" and target_type == "cost":
            return int(base_value * event["multiplier"])
            
        return base_value
