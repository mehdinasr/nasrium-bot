class GuardEngine:
    # تعریف یگان‌های گارد {type: {cost_hard, def_multiplier}}
    GUARD_TYPES = {
        "praetorian": {"name": "Shadow Praetorian", "cost": 100, "def_boost": 1.5},
        "vanguard": {"name": "Imperial Vanguard", "cost": 250, "def_boost": 2.2}
    }

    @staticmethod
    def recruit_guard(player_data, guard_type):
        unit = GuardEngine.GUARD_TYPES.get(guard_type)
        if not unit: return False, "Invalid Guard Class."

        if player_data.get("nsm_hard", 0) < unit["cost"]:
            return False, "Insufficient Premium NSM for Royal Recruitment."

        player_data["nsm_hard"] -= unit["cost"]
        player_data["active_guard"] = guard_type
        player_data["guard_expiry"] = 2592000 # ۳۰ روز اعتبار
        
        return True, f"Imperial Oath Sworn: {unit['name']} is now protecting your Sanctum."
