import time

class SubscriptionEngine:
    BOOSTS = {
        "gold_miner": {"price": 500, "duration": 86400, "label": "2x Gold Production (24h)"},
        "energy_surge": {"price": 300, "duration": 3600, "label": "Fast Energy Recovery (1h)"}
    }

    @staticmethod
    def is_boost_active(player_data, boost_id):
        active_boosts = player_data.get("active_boosts", {})
        expiry = active_boosts.get(boost_id, 0)
        return time.time() < expiry

    @staticmethod
    def apply_boost(player_data, boost_id):
        if boost_id not in SubscriptionEngine.BOOSTS:
            return False, "Invalid Boost ID"
        
        price = SubscriptionEngine.BOOSTS[boost_id]["price"]
        if player_data.get("nsm_soft", 0) < price:
            return False, "Insufficient NSM Soft"

        # کسر هزینه و فعالسازی
        player_data["nsm_soft"] -= price
        duration = SubscriptionEngine.BOOSTS[boost_id]["duration"]
        
        active_boosts = player_data.get("active_boosts", {})
        # اگر بوست از قبل فعال بود زمان به آن اضافه میشود
        current_expiry = max(time.time(), active_boosts.get(boost_id, 0))
        active_boosts[boost_id] = current_expiry + duration
        player_data["active_boosts"] = active_boosts
        
        return True, f"Boost {boost_id} activated!"
