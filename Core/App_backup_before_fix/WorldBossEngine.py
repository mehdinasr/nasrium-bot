class WorldBossEngine:
    # مشخصات غول جهانی (در دیتابیس مرکزی ذخیره می شود)
    BOSS_STATS = {
        "id": "LV-01",
        "name": "THE LEVIATHAN VIRUS",
        "total_hp": 10000000,
        "current_hp": 7450000, # شبیه سازی سلامت باقی مانده
        "deadline": 1721000000,
        "reward_pool": 5000000 # طلا
    }

    @staticmethod
    def calculate_dmg(player_data):
        # آسیب بر اساس تعداد نیروها و سطح تکنولوژی Warfare
        troops = player_data.get("troops", 0)
        tech_bonus = player_data.get("research", {}).get("adv_optics", 0) * 0.1
        base_dmg = (troops * 0.5) * (1 + tech_bonus)
        return int(base_dmg)

    @staticmethod
    def process_attack(player_data, boss_data):
        dmg = WorldBossEngine.calculate_dmg(player_data)
        boss_data["current_hp"] = max(0, boss_data["current_hp"] - dmg)
        
        # ثبت امتیاز مشارکت بازیکن
        contribution = player_data.get("boss_contribution", 0)
        player_data["boss_contribution"] = contribution + dmg
        
        return dmg, boss_data
