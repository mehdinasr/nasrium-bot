class MilestoneEngine:
    VERSION = "2.0.0-ZENITH"
    TOTAL_STEPS = 500

    @staticmethod
    def apply_milestone_rewards(player_data):
        if player_data.get("milestone_500_claimed"):
            return False, "Sovereign Reward already secured."
        
        # اعطای پاداش بزرگ
        player_data["nsm_hard"] = player_data.get("nsm_hard", 0) + 500
        player_data["milestone_500_claimed"] = True
        
        # اضافه کردن مدال جاویدان
        medals = player_data.get("medals", [])
        if "PIONEER_500" not in medals:
            medals.append("PIONEER_500")
        player_data["medals"] = medals
        
        return True, "Imperial Decree: 500 NSM Hard and Pioneer Medal granted."
