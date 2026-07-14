import time

class LockdownEngine:
    # پارامترهای قرنطینه (هزینه فعال‌سازی: 50 NSM Hard)
    LOCKDOWN_DURATION = 14400 # ۴ ساعت قرنطینه مطلق
    ACTIVATE_COST_HARD = 50

    @staticmethod
    def trigger_lockdown(player_data):
        if player_data.get("nsm_hard", 0) < LockdownEngine.ACTIVATE_COST_HARD:
            return False, "Insufficient Premium NSM Credits for Emergency Lockdown."
        
        # بررسی اینکه آیا در حال حاضر در لاک‌داون است؟
        if time.time() < player_data.get("lockdown_until", 0):
            return False, "System is already under quarantine protocol."

        player_data["nsm_hard"] -= LockdownEngine.ACTIVATE_COST_HARD
        player_data["lockdown_until"] = time.time() + LockdownEngine.LOCKDOWN_DURATION
        
        return True, "SYSTEM LOCKDOWN ACTIVE: All ports sealed. Production halted for 4 hours."

    @staticmethod
    def is_locked(player_data):
        return time.time() < player_data.get("lockdown_until", 0)
