class AIEvolutionEngine:
    # تعریف تیپ‌های شخصیتی و بونوس‌های آن‌ها
    TRAITS = {
        "aggressive": {"name": "Aggressive", "bonus_type": "raid_loot", "value": 1.10, "desc": "+10% Raid Gold"},
        "defensive": {"name": "Defensive", "bonus_type": "anti_spy", "value": 1.10, "desc": "+10% Spy Defense"},
        "analytical": {"name": "Analytical", "bonus_type": "vault_interest", "value": 1.10, "desc": "+10% Vault Interest"}
    }

    @staticmethod
    def get_ai_trait(player_data):
        return player_data.get("ai_trait", "balanced")

    @staticmethod
    def apply_ai_bonus(player_data, base_value, target_bonus):
        trait_id = player_data.get("ai_trait")
        if not trait_id: return base_value
        
        trait_info = AIEvolutionEngine.TRAITS.get(trait_id)
        if trait_info and trait_info["bonus_type"] == target_bonus:
            return base_value * trait_info["value"]
        return base_value
