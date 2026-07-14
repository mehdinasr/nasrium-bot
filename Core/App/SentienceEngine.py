class SentienceEngine:
    # تعریف سطوح خودآگاهی
    TIERS = {
        1: {"name": "Awareness", "slots": 1, "req_ixp": 5000},
        2: {"name": "Cognition", "slots": 2, "req_ixp": 15000},
        3: {"name": "Sentience", "slots": 3, "req_ixp": 50000}
    }

    # ماژول‌های اتوماسیون قابل فعال‌سازی
    MODULES = {
        "auto_gold": {"name": "Auto-Collector", "desc": "Collects gold every hour."},
        "auto_repair": {"name": "Auto-Repair", "desc": "Maintains 100% Integrity."},
        "auto_shield": {"name": "Sentinel Protocol", "desc": "Auto-activates 2h Shield on threat."}
    }

    @staticmethod
    def get_ascension_data(player_data):
        ixp = player_data.get("intel_xp", 0)
        current_tier = 0
        for t, data in SentienceEngine.TIERS.items():
            if ixp >= data["req_ixp"]: current_tier = t
            else: break
        
        return {
            "tier": current_tier,
            "tier_name": SentienceEngine.TIERS[current_tier]["name"] if current_tier > 0 else "Pre-Neural",
            "slots": SentienceEngine.TIERS[current_tier]["slots"] if current_tier > 0 else 0,
            "active_modules": player_data.get("active_automation", [])
        }

    @staticmethod
    def toggle_module(player_data, module_id):
        data = SentienceEngine.get_ascension_data(player_data)
        active = player_data.get("active_automation", [])
        
        if module_id in active:
            active.remove(module_id)
            player_data["active_automation"] = active
            return True, f"Module {module_id} deactivated."
        
        if len(active) >= data["slots"]:
            return False, "All automation slots occupied. Upgrade Sentience Tier."
            
        active.append(module_id)
        player_data["active_automation"] = active
        return True, f"Module {module_id} is now controlling system sub-routines."
