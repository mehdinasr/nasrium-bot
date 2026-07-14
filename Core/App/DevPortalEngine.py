import uuid

class DevPortalEngine:
    # لیست برنامه‌های تأیید شده {app_id: {name, developer, status, share_pct}}
    REGISTERED_APPS = {
        "APP_001": {"name": "Slot Matrix", "dev": "Sovereign_Dev", "status": "Live", "fee": 0.20},
        "APP_002": {"name": "Raid Calculator", "dev": "Tech_Elite", "status": "Beta", "fee": 0.10}
    }

    @staticmethod
    def register_developer(player_data):
        # فقط بازیکنان سطح ۲۵ به بالا می‌توانند توسعه‌دهنده شوند
        if player_data.get("town_hall_lvl", 1) < 25:
            return False, "Access Denied: Level 25 required for Imperial Dev License."
        
        api_key = str(uuid.uuid4())
        player_data["dev_api_key"] = api_key
        player_data["is_developer"] = True
        return True, f"Dev License Granted. Your API Key: {api_key}"

    @staticmethod
    def get_market_apps():
        return DevPortalEngine.REGISTERED_APPS
