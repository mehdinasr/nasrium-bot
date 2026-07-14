class DiplomacyEngine:
    # تعریف انواع پیمان‌های دیپلماتیک
    PACTS = {
        "swap": {"name": "Knowledge Swap", "bonus": "XP Boost", "energy_cost": 10},
        "trade": {"name": "Trade Pact", "bonus": "Gold Multiplier", "energy_cost": 15},
        "intel": {"name": "Intel Exchange", "bonus": "Syndicate Influence", "energy_cost": 20}
    }

    @staticmethod
    def initiate_negotiation(attacker_data, target_data, pact_id):
        # بررسی وجود دستیار فعال در هر دو طرف
        if not attacker_data.get("active_agent") or not target_data.get("active_agent"):
            return False, "Both commanders must have an active AI Agent linked."
        
        # شانس موفقیت بر اساس هوش قهرمان
        a_intel = attacker_data.get("hero_stats", {}).get("intelligence", 10)
        t_intel = target_data.get("hero_stats", {}).get("intelligence", 10)
        
        success_chance = 50 + (a_intel - t_intel) # فرمول ساده دیپلماسی
        
        return True, f"Diplomatic envoy dispatched to {target_data['user_id']}. Waiting for response."

    @staticmethod
    def resolve_pact(player_data, pact_id):
        # اعمال پاداش‌های پیمان (ساده‌سازی شده برای این گام)
        return True, f"Pact {pact_id} finalized. Synergy established."
