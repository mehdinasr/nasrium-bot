import time

class InsuranceEngine:
    # طرح‌های بیمه نصریوم {id: {name, cost, coverage_pct}}
    PLANS = {
        "silver": {"name": "Silver Shield", "cost": 1000, "coverage": 0.20},
        "gold": {"name": "Gold Aegis", "cost": 5000, "coverage": 0.50},
        "imperial": {"name": "Imperial Guard", "cost": 15000, "coverage": 0.80}
    }

    @staticmethod
    def subscribe(player_data, plan_id):
        plan = InsuranceEngine.PLANS.get(plan_id)
        if not plan: return False, "Invalid Insurance Plan."

        if player_data.get("nsm_soft", 0) < plan["cost"]:
            return False, "Insufficient NSM Soft for insurance premium."

        player_data["nsm_soft"] -= plan["cost"]
        player_data["active_insurance"] = plan_id
        player_data["insurance_expiry"] = time.time() + 2592000 # ۳۰ روز
        
        return True, f"Imperial Protection Active: {plan['name']} is now covering your assets."

    @staticmethod
    def calculate_payout(player_data, lost_amount):
        plan_id = player_data.get("active_insurance")
        if not plan_id or time.time() > player_data.get("insurance_expiry", 0):
            return 0
        
        coverage = InsuranceEngine.PLANS[plan_id]["coverage"]
        return int(lost_amount * coverage)
