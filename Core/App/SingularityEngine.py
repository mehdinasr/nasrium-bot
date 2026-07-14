class SingularityEngine:
    # وضعیت جهانی تکینگی {current_ixp, target_ixp, is_active}
    GLOBAL_CORE = {
        "current_ixp": 450000,
        "target_ixp": 1000000,
        "level": 5,
        "is_active": False
    }

    @staticmethod
    def contribute_knowledge(player_data, amount):
        if player_data.get("intel_xp", 0) < amount:
            return False, "Your AI assistant does not possess enough IXP to contribute."
        
        player_data["intel_xp"] -= amount
        SingularityEngine.GLOBAL_CORE["current_ixp"] += amount
        
        # ثبت پاداش افتخار برای اهداکننده
        player_data["honor_score"] = player_data.get("honor_score", 0) + int(amount / 10)
        
        # بررسی فعال‌سازی تکینگی
        if SingularityEngine.GLOBAL_CORE["current_ixp"] >= SingularityEngine.GLOBAL_CORE["target_ixp"]:
            SingularityEngine.GLOBAL_CORE["is_active"] = True
            
        return True, f"Knowledge Injected: {amount} IXP merged into the Singularity Core."

    @staticmethod
    def get_core_status():
        return SingularityEngine.GLOBAL_CORE
