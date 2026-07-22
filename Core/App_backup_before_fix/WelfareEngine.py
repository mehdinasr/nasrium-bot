class WelfareEngine:
    # پارامترهای صندوق رفاه
    CONFIG = {
        "min_activity_score": 50,
        "base_payout": 2500,
        "pool_total": 1000000
    }

    @staticmethod
    def calculate_activity(player_data):
        # محاسبه امتیاز بر اساس متغیرهای مختلف
        raids = player_data.get("raid_count", 0)
        logins = player_data.get("tribute_streak", 0)
        return (raids * 5) + (logins * 10)

    @staticmethod
    def claim_welfare(player_data):
        score = WelfareEngine.calculate_activity(player_data)
        if score < WelfareEngine.CONFIG["min_activity_score"]:
            return False, f"Activity Score too low ({score}). Need 50 to qualify."
        
        if player_data.get("welfare_claimed_this_cycle"):
            return False, "You have already received your Imperial Welfare for this cycle."

        payout = WelfareEngine.CONFIG["base_payout"]
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + payout
        player_data["welfare_claimed_this_cycle"] = True
        
        return True, f"Welfare Distributed: +{payout} NSM added to your account. Glory to the Empire!"
