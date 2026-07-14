import time

class StealthEngine:
    # تعریف انواع سطوح اختفا
    MODES = {
        "ghost_2h": {"name": "Ghost v1 (2h)", "duration": 7200, "cost_nsm": 2000},
        "ghost_8h": {"name": "Ghost v2 (8h)", "duration": 28800, "cost_nsm": 6000}
    }

    @staticmethod
    def activate_stealth(player_data, mode_id):
        mode = StealthEngine.MODES.get(mode_id)
        if not mode: return False, "Invalid Stealth Mode."

        if player_data.get("nsm_soft", 0) < mode["cost_nsm"]:
            return False, "Insufficient NSM Soft for Stealth Protocol."

        # فعالسازی اختفا
        player_data["nsm_soft"] -= mode["cost_nsm"]
        player_data["stealth_until"] = time.time() + mode["duration"]
        
        return True, f"Base encrypted. You are now invisible for {mode['name']}."

    @staticmethod
    def is_visible(player_data):
        # چک کردن اینکه آیا بازیکن در حال حاضر مخفی است یا خیر
        return time.time() > player_data.get("stealth_until", 0)
