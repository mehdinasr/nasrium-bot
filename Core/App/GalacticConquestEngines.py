class GalacticConquestEngines:
    """ID_1051: مدیریت اعزام ناوگان به سیارات."""
    ACTIVE_MISSIONS = {} # {u_id: {"planet": str, "arrival_time": float}}

    @staticmethod
    def deploy_fleet(u_id, planet_name, fleet_power):
        import time
        # زمان رسیدن بر اساس دوری سیاره (شبیه سازی: 1 ساعت)
        arrival = time.time() + 3600
        GalacticConquestEngines.ACTIVE_MISSIONS[u_id] = {
            "planet": planet_name,
            "power": fleet_power,
            "arrival": arrival
        }
        return True, f"Fleet dispatched to {planet_name}. Arrival in 60 minutes."

    """ID_1052: مدیریت دکل های استخراج سیاره ای."""
    @staticmethod
    def calculate_planetary_yield(planet_name, rig_level):
        base_yield = 5000 # تولید بسیار بالاتر از ماه و زمین
        multipliers = {"CENTAURI_PRIME": 2.5, "VOID_SECTOR": 5.0}
        return base_yield * multipliers.get(planet_name, 1.0) * rig_level

class SpaceMarketEngine:
    """ID_1053: بازار سیاه بین سیاره ای برای آیتم های استراتژیک."""
    ITEMS = {
        "WARP_CORE": {"price_nsm": 2500, "desc": "Reduces fleet travel time by 50%"},
        "DARK_MATTER": {"price_nsm": 5000, "desc": "Instantly refills Quantum Energy"}
    }
