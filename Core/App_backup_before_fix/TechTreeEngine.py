class TechTreeEngine:
    TECHS = {
        "adv_optics": {"name": "Adv. Optics", "branch": "War", "base_cost": 10000},
        "nano_mining": {"name": "Nano Mining", "branch": "Eco", "base_cost": 8000},
        "neural_link": {"name": "Neural Link", "branch": "AI", "base_cost": 15000}
    }
    @staticmethod
    def start_research(player_data, tech_id):
        tech = TechTreeEngine.TECHS.get(tech_id)
        if not tech: return False, "Invalid Tech"
        lvl = player_data.get("research", {}).get(tech_id, 0)
        cost = int(tech["base_cost"] * (lvl + 1) * 1.5)
        if player_data.get("gold", 0) < cost: return False, "Low Gold"
        player_data["gold"] -= cost
        res = player_data.get("research", {})
        res[tech_id] = lvl + 1
        player_data["research"] = res
        return True, f"{tech['name']} Researched to Level {lvl+1}"
