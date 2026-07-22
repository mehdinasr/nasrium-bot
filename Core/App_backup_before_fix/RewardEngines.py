class RewardEngine:
    """CMD_970: مدیریت ایردراپ بزرگ بر اساس وفاداری و رتبه."""
    @staticmethod
    def calculate_airdrop(player_data):
        base_reward = 100 # ۱۰۰ توکن NSM پایه
        pioneer_multiplier = 2.0 if player_data.get("is_pioneer") else 1.0
        rank_bonus = player_data.get("level", 1) * 50
        
        total_airdrop = (base_reward + rank_bonus) * pioneer_multiplier
        return total_airdrop

class YieldEngine:
    """CMD_971: توزیع خودکار درآمدهای مالیاتی (Gas) بین استیک‌کنندگان."""
    @staticmethod
    def calculate_yield(staked_amount, global_tax_pool):
        # سهم هر نفر از استخر مالیاتی بر اساس مقدار استیک
        if staked_amount <= 0: return 0
        return (staked_amount * 0.001) # شبیه‌سازی سود روزانه ۰.۱٪ از تراکنش‌ها

class NSMAuction:
    """CMD_972: حراجی‌های فوق نایاب که فقط با NSM معامله می‌شوند."""
    AUCTION_ITEMS = [
        {"id": "divine_core", "name": "Divine AI Core", "min_bid_nsm": 500}
    ]
