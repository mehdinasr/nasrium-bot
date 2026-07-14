class AgentEngine:
    # تعریف دستیاران در دسترس و پاداش‌های آن‌ها
    AGENTS = {
        "tactician": {
            "name": "Aegis-7 (Tactician)",
            "desc": "Boosts military operations.",
            "buffs": {"atk_mult": 1.10, "regen_speed": 1.15}
        },
        "accountant": {
            "name": "Profit-X (Accountant)",
            "desc": "Optimizes gold production.",
            "buffs": {"gold_mult": 1.15, "cost_red": 0.90}
        },
        "sentinel": {
            "name": "Warden-1 (Sentinel)",
            "desc": "Reinforces city defenses.",
            "buffs": {"def_mult": 1.20, "shield_dur": 1.10}
        }
    }

    @staticmethod
    def assign_agent(player_data, agent_id):
        if agent_id not in AgentEngine.AGENTS:
            return False, "Agent profile not found."
        
        player_data["active_agent"] = agent_id
        agent_name = AgentEngine.AGENTS[agent_id]["name"]
        return True, f"Neural Link established with {agent_name}."
