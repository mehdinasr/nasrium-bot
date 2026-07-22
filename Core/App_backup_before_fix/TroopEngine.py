from Core.App.MilitaryTechEngine import MilitaryTechEngine
class TroopEngine:
    # تعریف انواع نیروها و مشخصات فنی
    UNIT_TYPES = {
        "scout": {"label": "Cyber Scout", "cost": 300, "power": 5, "desc": "Fast & Cheap"},
        "warrior": {"label": "Elite Warrior", "cost": 800, "power": 15, "desc": "Heavy Infantry"},
        "siege": {"label": "Siege Bot", "cost": 2500, "power": 60, "desc": "Wall Breaker"}
    }

    @staticmethod
    def calculate_total_power(player_data, troops_dict):
        # محاسبه قدرت کل بر اساس ترکیب نیروها
        total = 0
        for u_type, count in troops_dict.items():
            if u_type in TroopEngine.UNIT_TYPES:
                total += count * TroopEngine.UNIT_TYPES[u_type]["power"]
        return total

    @staticmethod
    def can_train(player_data, u_type, count=1):
        if u_type not in TroopEngine.UNIT_TYPES: return False, 0
        total_cost = TroopEngine.UNIT_TYPES[u_type]["cost"] * count
        return player_data.get("gold", 0) >= total_cost, total_cost
