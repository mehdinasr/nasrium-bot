class ResearchEngine:
    # تعریف درخت تکنولوژی ناصریوم
    TECH_TREE = {
        "auto_collect": {"name": "Auto-Collector", "cost": 5000, "nsm_cost": 100, "desc": "Automatic Gold Collection"},
        "precog": {"name": "Pre-cog Defense", "cost": 15000, "nsm_cost": 500, "desc": "5% Chance to evade Raids"},
        "efficiency": {"name": "Neural Efficiency", "cost": 25000, "nsm_cost": 1000, "desc": "-5 Energy consumption"}
    }

    @staticmethod
    def is_researched(player_data, tech_id):
        return tech_id in player_data.get("researched_techs", [])

    @staticmethod
    def start_research(player_data, tech_id):
        if tech_id not in ResearchEngine.TECH_TREE: return False, "Invalid Tech ID"
        if tech_id in player_data.get("researched_techs", []): return False, "Already Researched"
        
        tech = ResearchEngine.TECH_TREE[tech_id]
        if player_data.get("gold", 0) >= tech["cost"] and player_data.get("nsm_soft", 0) >= tech["nsm_cost"]:
            player_data["gold"] -= tech["cost"]
            player_data["nsm_soft"] -= tech["nsm_cost"]
            
            techs = player_data.get("researched_techs", [])
            techs.append(tech_id)
            player_data["researched_techs"] = techs
            return True, f"Success: {tech['name']} is now operational."
        return False, "Insufficient resources for AI Research."
