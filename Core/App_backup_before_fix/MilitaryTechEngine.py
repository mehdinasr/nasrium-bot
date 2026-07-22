class MilitaryTechEngine:
    # هزینه پایه ارتقا و ضریب افزایش قدرت
    TECH_CONFIG = {
        "scout": {"base_upgrade_cost": 2000, "power_per_lvl": 2},
        "warrior": {"base_upgrade_cost": 5000, "power_per_lvl": 5},
        "siege": {"base_upgrade_cost": 15000, "power_per_lvl": 15}
    }

    @staticmethod
    def get_tech_levels(player_data):
        return player_data.get("military_tech", {"scout": 1, "warrior": 1, "siege": 1})

    @staticmethod
    def calculate_unit_power(u_type, base_power, tech_level):
        # فرمول: قدرت پایه + (سطح تکنولوژی * ضریب قدرت)
        config = MilitaryTechEngine.TECH_CONFIG.get(u_type, {"power_per_lvl": 0})
        return base_power + (tech_level * config["power_per_lvl"])

    @staticmethod
    def get_upgrade_cost(u_type, current_level):
        base = MilitaryTechEngine.TECH_CONFIG[u_type]["base_upgrade_cost"]
        return int(base * (1.7 ** current_level))
