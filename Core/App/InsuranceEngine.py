import time

class InsuranceEngine:
    # تعریف پلن های بیمه
    PLANS = {
        "basic": {"name": "Basic Coverage", "cost_nsm": 500, "coverage": 0.50, "duration": 259200}, # 3 days
        "premium": {"name": "Citadel Premium", "cost_nsm": 1500, "coverage": 0.80, "duration": 604800} # 7 days
    }

    @staticmethod
    def is_insured(player_data):
        return time.time() < player_data.get("insurance_until", 0)

    @staticmethod
    def get_coverage_rate(player_data):
        if not InsuranceEngine.is_insured(player_data):
            return 0.0
        return player_data.get("insurance_rate", 0.0)

    @staticmethod
    def buy_policy(player_data, plan_id):
        plan = InsuranceEngine.PLANS.get(plan_id)
        if not plan: return False, "Invalid Plan ID."

        if player_data.get("nsm_soft", 0) < plan["cost_nsm"]:
            return False, "Insufficient NSM Soft for this policy."

        # کسر هزینه و فعال‌سازی
        player_data["nsm_soft"] -= plan["cost_nsm"]
        current_expiry = max(time.time(), player_data.get("insurance_until", 0))
        player_data["insurance_until"] = current_expiry + plan["duration"]
        player_data["insurance_rate"] = plan["coverage"]
        
        return True, f"Policy {plan['name']} activated!"
