class ImperialIDEngine:
    # سطوح شهروندی و بوف‌های تولید
    TIERS = {
        "CITIZEN": {"name": "Standard Citizen", "buff": 1.0, "min_level": 1},
        "VETERAN": {"name": "Imperial Veteran", "buff": 1.1, "min_level": 10},
        "ELITE": {"name": "Imperial Elite", "buff": 1.25, "min_level": 25},
        "SOVEREIGN": {"name": "Imperial Sovereign", "buff": 1.5, "min_level": 50}
    }

    @staticmethod
    def get_id_metadata(player_data):
        # تولید متادیتا برای شناسنامه دیجیتال
        th_lvl = player_data.get("town_hall_lvl", 1)
        tier = "CITIZEN"
        if th_lvl >= 50: tier = "SOVEREIGN"
        elif th_lvl >= 25: tier = "ELITE"
        elif th_lvl >= 10: tier = "VETERAN"

        return {
            "id_number": f"NSM-{player_data['user_id']}",
            "tier": tier,
            "tier_name": ImperialIDEngine.TIERS[tier]["name"],
            "production_multiplier": ImperialIDEngine.TIERS[tier]["buff"],
            "issue_date": player_data.get("join_date", "2026-07-14")
        }
