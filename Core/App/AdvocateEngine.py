class AdvocateEngine:
    # سطوح وکالت بر اساس لول خودمختاری AI
    LEGAL_BONUSES = {
        0: {"title": "Observer", "fee_reduction": 0.0, "payout_bonus": 0.0},
        1: {"title": "Legal Analyst", "fee_reduction": 0.10, "payout_bonus": 0.05},
        2: {"title": "Senior Advocate", "fee_reduction": 0.20, "payout_bonus": 0.15},
        3: {"title": "Supreme Jurist", "fee_reduction": 0.35, "payout_bonus": 0.30}
    }

    @staticmethod
    def get_legal_standing(player_data):
        ai_lvl = player_data.get("ai_autonomy_lvl", 0)
        return AdvocateEngine.LEGAL_BONUSES.get(ai_lvl, AdvocateEngine.LEGAL_BONUSES[0])

    @staticmethod
    def apply_defense(player_data, action_type):
        standing = AdvocateEngine.get_legal_standing(player_data)
        if action_type == "COURT_FEE":
            return standing["fee_reduction"]
        elif action_type == "INSURANCE_CLAIM":
            return standing["payout_bonus"]
        return 0.0
