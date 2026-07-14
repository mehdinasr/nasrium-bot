class AscensionEngine:
    """
    مدیریت ارتقای سطح و عناوین شهروندان نصریوم.
    """
    TITLES = {
        1: "Citizen", 2: "Technician", 3: "Specialist", 
        4: "Officer", 5: "Commander", 6: "High Council", 
        7: "Archon", 8: "Sovereign"
    }

    @staticmethod
    def get_upgrade_cost(current_level):
        # هزینه ارتقا: (سطح فعلی ^ 2) * 5000
        return (current_level ** 2) * 5000

    @staticmethod
    def ascend_player(player_data):
        current_lvl = player_data.get("level", 1)
        cost = AscensionEngine.get_upgrade_cost(current_lvl)
        
        if player_data.get("intel_xp", 0) < cost:
            return False, f"Insufficient IXP. You need {cost} to ascend."
        
        if current_lvl >= 8:
            return False, "You have reached the maximum rank of Sovereign."

        player_data["intel_xp"] -= cost
        player_data["level"] = current_lvl + 1
        player_data["rank"] = AscensionEngine.TITLES.get(player_data["level"])
        
        # پاداش دائمی: افزایش قدرت آرنا یا نرخ استخراج (به صورت فرضی)
        player_data["mining_boost"] = player_data.get("mining_boost", 1.0) + 0.1
        
        return True, f"Ascension Successful! You are now a {player_data['rank']}."
