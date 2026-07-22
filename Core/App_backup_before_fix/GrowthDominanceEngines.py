import time

class GrowthDominanceEngine:
    """مدیریت پاداش های دعوت انبوه و هدایای ورودی."""
    GENESIS_GIFT = 10000 # 10k IXP برای هر ورودی جدید
    REFERRAL_BOOST = 0.20 # 20 درصد پاداش برای دعوت کننده

    @staticmethod
    def claim_genesis_gift(player_data):
        if not player_data.get("genesis_gift_claimed"):
            player_data["intel_xp"] += GrowthDominanceEngine.GENESIS_GIFT
            player_data["genesis_gift_claimed"] = True
            return True, "Genesis gift infused."
        return False, "Already claimed."

class RetentionHeartbeat:
    """سیستم پاداش برای حضور مداوم شهروندان."""
    @staticmethod
    def calculate_stay_bonus(minutes):
        return minutes * 100 # 100 IXP per minute active
