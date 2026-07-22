class SiloEngine:
    BASE_CAPACITY = 5000 

    @staticmethod
    def get_max_capacity(player_data):
        # ظرفیت بر اساس سطح نکسوس افزایش می‌یابد
        lvl = player_data.get('town_hall_level', 1)
        return int(SiloEngine.BASE_CAPACITY * (1.8 ** (lvl - 1)))

    @staticmethod
    def is_full(player_data):
        current_gold = player_data.get('gold', 0)
        max_cap = SiloEngine.get_max_capacity(player_data)
        return current_gold >= max_cap

    @staticmethod
    def get_storage_percent(player_data):
        current = player_data.get('gold', 0)
        max_cap = SiloEngine.get_max_capacity(player_data)
        return min(100, int((current / max_cap) * 100))
