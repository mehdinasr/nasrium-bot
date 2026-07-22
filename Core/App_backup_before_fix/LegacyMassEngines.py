import time
import random

class HeirEngine:
    """CMD_950: سیستم وارثان برای انتقال قدرت به نسل جدید با امتیازات ویژه."""
    @staticmethod
    def nominate_heir(player_data):
        if player_data.get("level", 1) < 8:
            return False, "Only Sovereigns can nominate a System Heir."
        
        player_data["has_heir"] = True
        player_data["heir_bonus"] = player_data.get("heir_bonus", 0) + 0.25
        return True, "Successor nominated. Your legacy will be 25% more efficient."

class BigBangEvent:
    """CMD_951: مدیریت رویداد انفجار بزرگ IXP (توزیع انبوه)."""
    COUNTDOWN_END = time.time() + 86400 # ۲۴ ساعت تا انفجار بزرگ
    TOTAL_POOL = 100000000 # ۱۰۰ میلیون IXP

    @staticmethod
    def get_event_status():
        remaining = BigBangEvent.COUNTDOWN_END - time.time()
        return {
            "is_active": remaining > 0,
            "seconds_left": int(remaining),
            "pool": BigBangEvent.TOTAL_POOL
        }

class CommandPost:
    """CMD_952: داده‌های مرکز فرماندهی مجازی."""
    @staticmethod
    def get_cockpit_data(player_data):
        return {
            "integrity": "99.9%",
            "system_status": "OPTIMAL",
            "shield_level": player_data.get("level", 1) * 12,
            "ai_sync": "SYNCHRONIZED"
        }
