import time
import random

class MerchantEngine:
    # لیست کالاهای احتمالی کاروان
    POTENTIAL_DEALS = [
        {"id": "deal_gold_pack", "name": "Refined Fuel", "cost_nsm": 200, "reward_gold": 10000},
        {"id": "deal_xp_boost", "name": "Neural Data", "cost_gold": 5000, "reward_xp": 500},
        {"id": "deal_scout_contract", "name": "Mercenary Scouts", "cost_gold": 2000, "reward_troops": 10}
    ]

    @staticmethod
    def get_current_deals():
        # در این نسخه، بر اساس بازه‌های 6 ساعته کالاها تغییر می‌کنند
        current_window = int(time.time() / 21600)
        random.seed(current_window)
        # انتخاب 2 کالای تصادفی برای این بازه زمانی
        return random.sample(MerchantEngine.POTENTIAL_DEALS, 2)

    @staticmethod
    def get_time_until_next_rotation():
        next_rotation = (int(time.time() / 21600) + 1) * 21600
        return int(next_rotation - time.time())
