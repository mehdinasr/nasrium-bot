import time

class ExpeditionEngine:
    # تعریف انواع ماموریت‌ها
    MISSIONS = {
        "scout": {"name": "Border Scouting", "duration": 14400, "base_gold": 5000, "base_xp": 200},
        "mine": {"name": "Data Mining", "duration": 14400, "base_gold": 15000, "base_xp": 50},
        "patrol": {"name": "Cyber Patrol", "duration": 14400, "base_gold": 2000, "base_xp": 500}
    }

    @staticmethod
    def start_expedition(player_data, mission_id):
        if not player_data.get("active_agent"):
            return False, "No active AI Agent linked."
        if player_data.get("agent_busy_until", 0) > time.time():
            return False, "AI Agent is currently deployed."

        mission = ExpeditionEngine.MISSIONS.get(mission_id)
        player_data["agent_busy_until"] = time.time() + mission["duration"]
        player_data["current_mission"] = mission_id
        
        return True, f"Agent dispatched for {mission['name']}."

    @staticmethod
    def claim_expedition(player_data):
        if player_data.get("agent_busy_until", 0) > time.time():
            return False, "Mission in progress.", None
        
        m_id = player_data.get("current_mission")
        if not m_id: return False, "No active mission to claim.", None
        
        mission = ExpeditionEngine.MISSIONS[m_id]
        agent_id = player_data.get("active_agent")
        
        # اعمال بونوس‌های دستیار
        gold_gain = mission["base_gold"]
        xp_gain = mission["base_xp"]
        
        if agent_id == "accountant": gold_gain *= 1.5
        if agent_id == "tactician": xp_gain *= 1.5
        
        # پاکسازی وضعیت ماموریت
        player_data["current_mission"] = None
        player_data["agent_busy_until"] = 0
        
        return True, f"Mission Complete! Gained {int(gold_gain)} Gold and {int(xp_gain)} XP.", {"gold": gold_gain, "xp": xp_gain}
