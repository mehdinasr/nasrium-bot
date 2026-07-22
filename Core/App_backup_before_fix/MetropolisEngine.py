class MetropolisEngine:
    # تعریف انواع ساختمان‌ها و ویژگی‌های آن‌ها
    BUILDING_TYPES = {
        "nexus": {"label": "NEXUS Core", "desc": "Empire Heart", "base_cost": 5000},
        "gold_mine": {"label": "Gold Mine", "desc": "Generates Wealth", "base_cost": 1000},
        "barracks": {"label": "Barracks", "desc": "Trains Soldiers", "base_cost": 1500},

        "tesla_tower": {"label": "Tesla Tower", "desc": "Destroys Attackers", "base_cost": 2000},
        "cyber_wall": {"label": "Cyber Wall", "desc": "Protects Gold", "base_cost": 3000},
    
    }

    @staticmethod
    def get_building_level(player_data, b_type):
        buildings = player_data.get("buildings", {})
        return buildings.get(b_type, 1 if b_type == "nexus" else 0)

    @staticmethod
    def calculate_upgrade_cost(b_type, current_level):
        base = MetropolisEngine.BUILDING_TYPES[b_type]["base_cost"]
        return int(base * (1.6 ** current_level))
