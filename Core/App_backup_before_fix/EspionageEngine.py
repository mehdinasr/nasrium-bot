import random
import time

class EspionageEngine:
    # تعریف انواع عملیات و پارامترها
    OPERATIONS = {
        "intel": {"name": "Intel Leak", "base_chance": 0.8, "cost_ixp": 50},
        "siphon": {"name": "Resource Siphon", "base_chance": 0.5, "cost_ixp": 150},
        "sabotage": {"name": "System Sabotage", "base_chance": 0.3, "cost_ixp": 300}
    }

    @staticmethod
    def dispatch_spy(player_data, target_id, op_type):
        op = EspionageEngine.OPERATIONS.get(op_type)
        if not op: return False, "Invalid Operation Protocol."

        if player_data.get("intel_xp", 0) < op["cost_ixp"]:
            return False, "Insufficient Intelligence XP for Shadow Ops."

        # کسر هزینه عملیات
        player_data["intel_xp"] -= op["cost_ixp"]
        
        # محاسبه شانس موفقیت (تاثیر لول AI)
        ai_bonus = player_data.get("ai_level", 1) * 0.02
        final_chance = op["base_chance"] + ai_bonus
        
        success = random.random() < final_chance
        
        if success:
            return True, f"Success! {op['name']} completed against target {target_id}."
        else:
            # شکست منجر به کسر افتخار می‌شود
            player_data["honor_score"] = max(0, player_data.get("honor_score", 0) - 10)
            return False, f"Failed! Spy detected by target {target_id}. Honor penalized."
