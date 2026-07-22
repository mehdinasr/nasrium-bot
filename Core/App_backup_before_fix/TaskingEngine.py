import time

class TaskingEngine:
    # تعریف بونوس‌های نکسوس برای هر ساختمان
    TASK_BUFFS = {
        "gold_mine": {"type": "economy", "value": 0.30, "label": "Neural Extraction"},
        "barracks": {"type": "military", "value": 0.20, "label": "AI Drills"},
        "tesla_tower": {"type": "defense", "value": 0.25, "label": "Targeting Sync"}
    }

    @staticmethod
    def get_active_assignment(player_data):
        assign = player_data.get("ai_assignment", {})
        if not assign: return None
        
        # بررسی انقضای ماموریت (۲۴ ساعت)
        if time.time() > assign.get("expires_at", 0):
            return None
        return assign

    @staticmethod
    def assign_ai(player_data, building_type):
        if building_type not in TaskingEngine.TASK_BUFFS:
            return False, "Invalid building type."
        
        # هر بار فقط یک ساختمان می‌تواند میزبان نکسوس باشد
        player_data["ai_assignment"] = {
            "target": building_type,
            "expires_at": time.time() + 86400, # ۲۴ ساعت
            "label": TaskingEngine.TASK_BUFFS[building_type]["label"]
        }
        return True, f"NAXUS assigned to {building_type} for 24 hours."
