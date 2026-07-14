class AwakeningEngine:
    # سطوح خودمختاری {level: {name, capability, cost_ixp}}
    AUTONOMY_TIERS = {
        1: {"name": "Reactive Spirit", "desc": "Auto-repair buildings below 20% integrity.", "cost": 500},
        2: {"name": "Sentinel Mind", "desc": "Auto-deploy drones during raid detection.", "cost": 2500},
        3: {"name": "Sovereign Soul", "desc": "Independent tactical counter-strikes.", "cost": 10000}
    }

    @staticmethod
    def process_offline_defense(player_data, event_type):
        if not player_data.get("ai_autonomy_active", False):
            return False, "AI Autonomy is currently inhibited."
        
        # منطق واکنش خودکار (ساده‌سازی شده)
        if event_type == "RAID" and player_data.get("ai_autonomy_lvl", 0) >= 2:
            return True, "AI Assistant deployed drones independently."
        return False, "No autonomous response triggered."

    @staticmethod
    def upgrade_consciousness(player_data):
        current_lvl = player_data.get("ai_autonomy_lvl", 0)
        next_lvl = current_lvl + 1
        tier = AwakeningEngine.AUTONOMY_TIERS.get(next_lvl)
        
        if not tier: return False, "Maximum consciousness level reached."
        if player_data.get("intel_xp", 0) < tier["cost"]:
            return False, f"Insufficient IXP. Need {tier['cost']} for awakening."

        player_data["intel_xp"] -= tier["cost"]
        player_data["ai_autonomy_lvl"] = next_lvl
        return True, f"Awakening Successful: AI is now a {tier['name']}."
