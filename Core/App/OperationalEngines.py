class TrafficGovernor:
    """ID_1004: کنترل سیل کاربران و جلوگیری از کرش کردن سرور."""
    MAX_CCU = 1000000
    CURRENT_LOAD = 0

    @staticmethod
    def allow_entry():
        if TrafficGovernor.CURRENT_LOAD < TrafficGovernor.MAX_CCU:
            TrafficGovernor.CURRENT_LOAD += 1
            return True
        return False

class InfluenceEngine:
    """ID_1005: موتور نفوذ برای پاداش‌دهی به سفیران بزرگ."""
    @staticmethod
    def calculate_influence_bonus(referral_count):
        # پاداش تصاعدی: هرچه تعداد دعوت بیشتر، قدرت استخراج کل شبکه لیدر بیشتر
        return 1.0 + (referral_count * 0.05)

class MinistrySystem:
    """ID_1006: سیستم انتصاب مقام‌های عالی توسط خالق."""
    MINISTERS = {
        "WAR": None,
        "FINANCE": None,
        "COMMUNICATION": None
    }

    @staticmethod
    def appoint_minister(role, u_id):
        if role in MinistrySystem.MINISTERS:
            MinistrySystem.MINISTERS[role] = u_id
            return True, f"Citizen {u_id} has been appointed as Minister of {role}."
        return False, "Invalid Role."
