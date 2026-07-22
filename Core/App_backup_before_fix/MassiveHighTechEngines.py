class GamblingEngine:
    """ID_1022: سیستم شرط‌بندی کیهانی."""
    @staticmethod
    def calculate_odds(multiplier):
        return 1 / multiplier

class CoopPortal:
    """ID_1024: پورتال استخراج اشتراکی (نیاز به ۲ نفر)."""
    ACTIVE_SESSIONS = {} # {session_id: [u1, u2]}
    @staticmethod
    def open_portal(u1, u2):
        return f"PORTAL_OPEN_REWARD_X2_ACTIVE"
