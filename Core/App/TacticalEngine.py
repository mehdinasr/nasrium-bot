import time

class TacticalEngine:
    # تعریف انواع حملات تاکتیکی
    STRIKES = {
        "emp": {"name": "EMP Blast", "duration": 1800, "cost_nsm": 5000, "effect": "Walls Offline"},
        "logic_bomb": {"name": "Logic Bomb", "duration": 3600, "cost_nsm": 8000, "effect": "Production -50%"}
    }

    @staticmethod
    def execute_strike(attacker_data, target_data, strike_id):
        strike = TacticalEngine.STRIKES.get(strike_id)
        if not strike: return False, "Invalid Strike Protocol."

        if attacker_data.get("nsm_soft", 0) < strike["cost_nsm"]:
            return False, "Insufficient NSM Soft for Tactical Launch."

        # اعمال اختلال در دیتای هدف (ساده‌سازی شده برای این گام)
        target_disruptions = target_data.get("active_disruptions", {})
        target_disruptions[strike_id] = time.time() + strike["duration"]
        target_data["active_disruptions"] = target_disruptions

        attacker_data["nsm_soft"] -= strike["cost_nsm"]
        return True, f"Tactical {strike['name']} successfully uploaded to {target_data['user_id']}."
