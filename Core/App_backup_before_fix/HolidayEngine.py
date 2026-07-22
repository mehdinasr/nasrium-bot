import time
from datetime import datetime

class HolidayEngine:
    # تقویم تعطیلات امپراتوری {اسم: (ماه، روز)}
    HOLIDAY_CALENDAR = {
        "Genesis Day": (7, 14), # روز تاسیس ناصریوم
        "AI Awakening": (10, 1),
        "Sovereign Solstice": (12, 21)
    }

    @staticmethod
    def is_holiday_active():
        now = datetime.utcnow()
        for name, date in HolidayEngine.HOLIDAY_CALENDAR.items():
            if now.month == date[0] and now.day == date[1]:
                return True, name
        return False, None

    @staticmethod
    def get_multipliers():
        active, name = HolidayEngine.is_holiday_active()
        if active:
            return {"prod": 2.0, "energy": 2.0, "peace_mode": True, "event": name}
        return {"prod": 1.0, "energy": 1.0, "peace_mode": False, "event": None}
