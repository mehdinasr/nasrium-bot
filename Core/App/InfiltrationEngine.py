import random
import time

class InfiltrationEngine:
    @staticmethod
    def run_scan(intel_lvl, target_data):
        chance = 60 + (intel_lvl * 2)
        if random.randint(1, 100) <= chance:
            return {"success": True, "gold": target_data.get("gold", 0), "power": "Online"}
        return {"success": False}

    @staticmethod
    def sabotage_power(intel_lvl, target_data):
        # شانس موفقیت پایه ۴۰٪ + تاثیر هوش
        chance = 40 + (intel_lvl * 1.5)
        if random.randint(1, 100) <= chance:
            # از کار انداختن نیروگاه برای ۳ ساعت
            return True, time.time() + 10800
        return False, 0
