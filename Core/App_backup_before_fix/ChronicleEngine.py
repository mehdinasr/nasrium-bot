class ChronicleEngine:
    MILESTONES = {
        "m_gold_millionaire": {"name": "Golden Age", "goal": 1000000, "type": "gold", "honor": 5000},
        "m_war_hero": {"name": "Warlord", "goal": 50, "type": "raid_wins", "honor": 3000},
        "m_ai_evolution": {"name": "Transhumanist", "goal": 5, "type": "ai_level", "honor": 4000}
    }

    @staticmethod
    def calculate_total_honor(player_data):
        gpi = player_data.get("power_score", 0)
        shards = player_data.get("nsm_shards", 0)
        streak = player_data.get("daily_streak", 0)
        syndicate_inf = 500 
        honor_points = (syndicate_inf * 0.5) + (gpi * 0.2) + (shards * 10) + (streak * 100)
        return int(honor_points)

    @staticmethod
    def get_milestone_progress(player_data):
        results = []
        for mid, m in ChronicleEngine.MILESTONES.items():
            current = 0
            if m["type"] == "gold": current = player_data.get("gold", 0)
            elif m["type"] == "raid_wins": current = player_data.get("raid_wins", 0)
            elif m["type"] == "ai_level": current = sum(player_data.get("ai_evolution", {}).values())
            progress = min(100, int((current / m["goal"]) * 100))
            results.append({"id": mid, "name": m["name"], "progress": progress, "is_completed": progress >= 100})
        return results
