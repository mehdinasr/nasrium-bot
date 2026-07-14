class BurnEngine:
    # آمار کل توکن‌های از دسترس خارج شده
    STATS = {
        "total_burned": 0,
        "burn_rate_daily": 15000, # میانگین شبیه‌سازی شده
        "supply_status": "DEFLATIONARY"
    }

    @staticmethod
    def register_burn(amount):
        # این تابع توسط سایر موتورها صدا زده می‌شود
        BurnEngine.STATS["total_burned"] += int(amount)
        return True

    @staticmethod
    def get_stats():
        return BurnEngine.STATS
