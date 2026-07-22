class RepairEngine:
    @staticmethod
    def get_building_health(player_data, b_type):
        # دریافت سلامت ساختمان (پیش فرض 100)
        durability = player_data.get("durability", {})
        return durability.get(b_type, 100)

    @staticmethod
    def calculate_repair_cost(b_type, current_lvl, health):
        # هزینه تعمیر بر اساس مقدار آسیب و لول ساختمان
        damage = 100 - health
        if damage <= 0: return 0
        base_repair_unit = 50 # هزینه هر 1 درصد تعمیر
        return int(damage * base_repair_unit * (1.2 ** current_lvl))

    @staticmethod
    def apply_raid_damage(player_data, won_defense):
        durability = player_data.get("durability", {"nexus":100, "gold_mine":100, "barracks":100, "tesla_tower":100, "cyber_wall":100})
        # اگر دفاع شکست بخورد آسیب بیشتر است (15-25 درصد) و اگر پیروز شود کمتر (5-10 درصد)
        damage_min = 5 if won_defense else 15
        damage_max = 10 if won_defense else 25
        
        import random
        for b_type in durability:
            reduction = random.randint(damage_min, damage_max)
            durability[b_type] = max(0, durability[b_type] - reduction)
        
        player_data["durability"] = durability
        return player_data
