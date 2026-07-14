class PublicLaunchEngine:
    """
    مدیریت ورود سیل‌آسای کاربران در لحظه انتشار.
    """
    GENESIS_BONUS = 5000  # پاداش ۵۰۰۰ واحدی برای پیشگامان
    IS_PUBLIC_OPEN = True

    @staticmethod
    def process_new_citizen(player_data):
        if player_data.get("is_pioneer", False):
            return False, "You are already a recognized Pioneer."
        
        # تزریق سرمایه اولیه به شهروند جدید
        player_data["intel_xp"] = player_data.get("intel_xp", 0) + PublicLaunchEngine.GENESIS_BONUS
        player_data["is_pioneer"] = True
        player_data["rank"] = "Genesis Citizen"
        player_data["access_level"] = 1
        
        return True, f"Welcome to Nasrium! {PublicLaunchEngine.GENESIS_BONUS} IXP has been infused into your neural core."

    @staticmethod
    def get_launch_stats():
        return {"status": "GLOBAL_LIVE", "bonus_active": True}
