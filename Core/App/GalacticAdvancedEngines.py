class GalacticLogisticsEngine:
    """مدیریت ایستگاه های فضایی و مسیرهای تجاری."""
    STATIONS = {} # {sector_id: {"level": int, "capacity": int}}
    
    @staticmethod
    def upgrade_station(sector_id):
        if sector_id not in GalacticLogisticsEngine.STATIONS:
            GalacticLogisticsEngine.STATIONS[sector_id] = {"level": 1, "capacity": 1000}
            return True, "Space station established."
        GalacticLogisticsEngine.STATIONS[sector_id]["level"] += 1
        return True, "Station efficiency increased."

class ResourceRefinery:
    """تصفیه منابع نایاب برای تبدیل به سوخت وارپ."""
    @staticmethod
    def process_exotic_matter(amount):
        return amount * 0.15 # بازدهی 15 درصد
