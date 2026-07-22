class MonumentEngine:
    # تعریف بناهای عظیم و هزینه‌های احداث
    MONUMENTS = {
        "gold_obelisk": {"name": "Golden Obelisk", "cost_gold": 1000000, "cost_nsm": 25000, "bonus": "Capacity +15%"},
        "citadel_spire": {"name": "Citadel Spire", "cost_gold": 1000000, "cost_nsm": 25000, "bonus": "Defense +20%"},
        "neural_monolith": {"name": "Neural Monolith", "cost_gold": 1000000, "cost_nsm": 25000, "bonus": "Energy Regen +25%"}
    }

    @staticmethod
    def construct_monument(player_data, mon_id):
        if mon_id not in MonumentEngine.MONUMENTS:
            return False, "Invalid Monument ID."
        
        if player_data.get("active_monument"):
            return False, "Your city already hosts a Strategic Monument."

        mon = MonumentEngine.MONUMENTS[mon_id]
        if player_data.get("gold", 0) < mon["cost_gold"] or player_data.get("nsm_soft", 0) < mon["cost_nsm"]:
            return False, "Insufficient resources for this grand construction."

        # کسر منابع و ثبت بنا
        player_data["gold"] -= mon["cost_gold"]
        player_data["nsm_soft"] -= mon["cost_nsm"]
        player_data["active_monument"] = mon_id
        
        return True, f"Construction Complete: The {mon['name']} now towers over your city."
