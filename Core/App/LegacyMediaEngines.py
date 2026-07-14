class RebirthEngine:
    """CMD_938: سیستم وراثت و تولد دوباره برای دریافت مولتی‌پلیرهای دائمی."""
    @staticmethod
    def can_rebirth(player_data):
        return player_data.get("level", 1) >= 8 and player_data.get("intel_xp", 0) >= 10000000

    @staticmethod
    def execute_rebirth(player_data):
        if not RebirthEngine.can_rebirth(player_data):
            return False, "You have not reached the pinnacle of Level 8 or 10M IXP."
        
        # ریست کردن آمار در ازای بوف دائمی
        player_data["generation"] = player_data.get("generation", 1) + 1
        player_data["level"] = 1
        player_data["intel_xp"] = 100000 # سرمایه اولیه برای نسل جدید
        player_data["permanent_multiplier"] = player_data.get("permanent_multiplier", 1.0) + 0.5
        
        return True, f"Rebirth Complete! Welcome to Generation {player_data['generation']}. Your power is now 1.5x."

class AmbassadorHall:
    """CMD_939: سیستم VIP برای سفیران بزرگ (رفرال‌های بالای ۵۰ نفر)."""
    @staticmethod
    def check_ambassador_status(player_data):
        ref_count = len(player_data.get("referrals", []))
        if ref_count >= 50:
            player_data["is_ambassador"] = True
            player_data["rank"] = "Imperial Ambassador"
            return True
        return False

class NasriumRadio:
    """CMD_940: ایستگاه رادیویی و اخبار امپراتوری."""
    TRACKS = [
        {"id": 1, "name": "Cyber Silence", "url": "static/audio/track1.mp3"},
        {"id": 2, "name": "Pure Ecosystem", "url": "static/audio/track2.mp3"}
    ]
    NEWS = [
        "The Creator has initiated the Rebirth Protocol.",
        "Legion 'Alpha' is dominating the War Room.",
        "New Artifact found in Sector 7."
    ]
