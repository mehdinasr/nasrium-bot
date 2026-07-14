class EvolutionEngine:
    # تعریف زیربرنامه‌های قابل ارتقا
    ROUTINES = {
        "auto_repair": {"name": "Auto-Repair v2", "desc": "+5 Integrity/hr", "base_cost": 500},
        "logic_boost": {"name": "Logic Booster", "desc": "+5% Diplomatic Gain", "base_cost": 800},
        "data_siphon": {"name": "Data Siphon", "desc": "+10% Sync Gold", "base_cost": 1200}
    }

    @staticmethod
    def get_evolution_status(player_data):
        return player_data.get("ai_evolution", {r: 0 for r in EvolutionEngine.ROUTINES})

    @staticmethod
    def upgrade_routine(player_data, routine_id):
        if routine_id not in EvolutionEngine.ROUTINES:
            return False, "Invalid Sub-Routine."
        
        evo_data = EvolutionEngine.get_evolution_status(player_data)
        current_lvl = evo_data.get(routine_id, 0)
        
        if current_lvl >= 5: return False, "Max level reached."

        cost = int(EvolutionEngine.ROUTINES[routine_id]["base_cost"] * (1.8 ** current_lvl))
        
        if player_data.get("intel_xp", 0) < cost:
            return False, f"Insufficient Intelligence XP. Need {cost}."

        # کسر هزینه و ارتقا
        player_data["intel_xp"] -= cost
        evo_data[routine_id] = current_lvl + 1
        player_data["ai_evolution"] = evo_data
        
        return True, f"Sub-Routine {EvolutionEngine.ROUTINES[routine_id]['name']} evolved to Level {current_lvl + 1}."
