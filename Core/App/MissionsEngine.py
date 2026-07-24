import time
import datetime


class MissionsEngine:
    MISSION_POOL = {
        "m_raid": {"name": "Frontline Aggressor", "goal": 3, "type": "raids", "reward_gold": 10000, "reward_honor": 50},
        "m_gold": {"name": "Industrial Titan", "goal": 50000, "type": "gold_mined", "reward_gold": 5000, "reward_honor": 30},
        "m_sync": {"name": "Neural Harmonizer", "goal": 1, "type": "sync_ops", "reward_gold": 20000, "reward_honor": 100}
    }

    @staticmethod
    def _today():
        return datetime.date.today().isoformat()

    @staticmethod
    def _ensure_fresh_day(player_data):
        today = MissionsEngine._today()
        if player_data.get("daily_mission_date") != today:
            player_data["daily_mission_date"] = today
            player_data["daily_counters"] = {"raids": 0, "gold_mined": 0, "sync_ops": 0}
            player_data["claimed_daily_missions"] = []

    @staticmethod
    def record_progress(player_data, mission_type, amount=1):
        MissionsEngine._ensure_fresh_day(player_data)
        counters = player_data.get("daily_counters", {})
        counters[mission_type] = counters.get(mission_type, 0) + amount
        player_data["daily_counters"] = counters
        return counters

    @staticmethod
    def get_daily_missions(player_data):
        MissionsEngine._ensure_fresh_day(player_data)
        active = player_data.get("active_missions", ["m_raid", "m_gold", "m_sync"])
        counters = player_data.get("daily_counters", {})
        claimed = player_data.get("claimed_daily_missions", [])
        results = []
        for mid in active:
            m = MissionsEngine.MISSION_POOL[mid]
            current_progress = counters.get(m["type"], 0)
            results.append({
                "id": mid,
                "name": m["name"],
                "progress": current_progress,
                "goal": m["goal"],
                "reward_gold": m["reward_gold"],
                "reward_honor": m["reward_honor"],
                "is_claimed": mid in claimed,
                "can_claim": current_progress >= m["goal"] and mid not in claimed
            })
        return results

    @staticmethod
    def claim_mission(player_data, mission_id):
        MissionsEngine._ensure_fresh_day(player_data)
        if mission_id in player_data.get("claimed_daily_missions", []):
            return False, "Mission rewards already claimed."
        m = MissionsEngine.MISSION_POOL.get(mission_id)
        if not m:
            return False, "Invalid mission."
        counters = player_data.get("daily_counters", {})
        if counters.get(m["type"], 0) < m["goal"]:
            return False, "Mission goal not yet reached."

        player_data["gold"] = player_data.get("gold", 0) + m["reward_gold"]
        player_data["power_score"] = player_data.get("power_score", 0) + m["reward_honor"]

        claimed = player_data.get("claimed_daily_missions", [])
        claimed.append(mission_id)
        player_data["claimed_daily_missions"] = claimed

        return True, f"Objective {m['name']} neutralized. Rewards deployed."
