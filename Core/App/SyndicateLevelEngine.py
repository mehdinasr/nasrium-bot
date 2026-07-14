class SyndicateLevelEngine:
    # تعریف نیازمندی‌های هر لول (XP مورد نیاز)
    LEVEL_CONFIG = {
        1: {"req_xp": 0, "buff": "New Alliance"},
        2: {"req_xp": 10000, "buff": "Energy Recovery +5%"},
        3: {"req_xp": 25000, "buff": "Gold Mining +5%"},
        4: {"req_xp": 60000, "buff": "Raid Power +5%"},
        5: {"req_xp": 150000, "buff": "Defense Shield +10%"}
    }

    @staticmethod
    def calculate_level(total_xp):
        current_lvl = 1
        for lvl, data in SyndicateLevelEngine.LEVEL_CONFIG.items():
            if total_xp >= data["req_xp"]:
                current_lvl = lvl
            else:
                break
        return current_lvl

    @staticmethod
    def get_contribution_value(gold, nsm):
        # فرمول تبدیل دارایی به XP سندیکا
        return int((gold / 100) + (nsm * 2))
