class SpaceInfrastructure:
    """ID_1057: مدیریت ایستگاه های فضایی مداری."""
    STATIONS = {} # {planet_name: {"level": int, "defense": int}}

    @staticmethod
    def build_station(planet_name):
        if planet_name not in SpaceInfrastructure.STATIONS:
            SpaceInfrastructure.STATIONS[planet_name] = {"level": 1, "defense": 1000}
            return True, f"Orbital Station established around {planet_name}."
        return False, "Station already exists."

class WormholeTech:
    """ID_1058: سیستم جابجایی آنی بین منظومه ای."""
    @staticmethod
    def calculate_jump_cost(distance):
        # هزینه جابجایی بر اساس فاصله به NSM
        return int(distance * 50)

class PlanetaryShields:
    """ID_1059: سپرهای محافظتی برای جلوگیری از غارت سیارات."""
    @staticmethod
    def activate_shield(planet_name, duration_hours):
        return True, f"Planetary Shield active on {planet_name} for {duration_hours} hours."
