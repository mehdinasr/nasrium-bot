import random

class ShadowBankEngine:
    """ID_1029: مدیریت سپرده گذاری های مخفی و ریسک کشف دارایی ها."""
    @staticmethod
    def deposit_hidden(player_data, amount):
        if player_data.get("intel_xp", 0) < amount:
            return False, "Insufficient IXP for shadow deposit."
        
        # انتقال به خزانه مخفی
        player_data["intel_xp"] -= amount
        player_data["shadow_balance"] = player_data.get("shadow_balance", 0) + amount
        
        # ریسک کشف توسط سیستم (1 درصد احتمال در هر واریز)
        if random.random() < 0.01:
            penalty = player_data["shadow_balance"] * 0.1
            player_data["shadow_balance"] -= penalty
            return True, f"Deposit successful, but High Court detected an anomaly. Penalty: {penalty} IXP."
            
        return True, f"Assets hidden. {amount} IXP moved to Shadow Vault."

    @staticmethod
    def get_shadow_status(player_data):
        return player_data.get("shadow_balance", 0)
