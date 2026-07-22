class AntivirusEngine:
    @staticmethod
    def get_defense_multiplier(player_data):
        # سطح Cyber Wall در Metropolis قدرت دفاع را تعیین می‌کند
        firewall_lvl = player_data.get("buildings", {}).get("cyber_wall", 0)
        # هر لول دیوار آتش، شانس هک شدن را ۵٪ کاهش می‌دهد
        return min(0.80, firewall_lvl * 0.05) 

    @staticmethod
    def repair_integrity(player_data):
        # هزینه تعمیر: ۵۰۰۰ طلا برای بازگشت به ۱۰۰٪
        current_integrity = player_data.get("integrity_score", 100)
        if current_integrity >= 100:
            return False, "System integrity is already at maximum."
        
        if player_data.get("gold", 0) < 5000:
            return False, "Insufficient Gold for system repair."
            
        player_data["gold"] -= 5000
        player_data["integrity_score"] = 100
        return True, "Neural Shield Repaired. Integrity at 100%."
