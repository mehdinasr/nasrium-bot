class RecycleEngine:
    BASE_RECOVERY_RATE = 0.20 # ۲۰٪ بازگشت منابع

    @staticmethod
    def calculate_salvage(player_data):
        # بررسی تعداد نیروهای کشته شده در آخرین نبردها
        graveyard = player_data.get("troop_graveyard", 0)
        if graveyard <= 0: return 0, 0
        
        # محاسبه طلا و اسقاطی قابل بازیابی
        gold_salvage = int(graveyard * 100 * RecycleEngine.BASE_RECOVERY_RATE)
        scrap_salvage = int(graveyard * 2 * RecycleEngine.BASE_RECOVERY_RATE)
        
        return gold_salvage, scrap_salvage

    @staticmethod
    def process_recycling(player_data):
        gold, scraps = RecycleEngine.calculate_salvage(player_data)
        if gold <= 0: return False, "No wreckage detected in the Smelter."

        player_data["gold"] = player_data.get("gold", 0) + gold
        player_data["scraps"] = player_data.get("scraps", 0) + scraps
        player_data["troop_graveyard"] = 0 # تخلیه گورستان
        
        return True, f"Recycling Complete: +{gold} Gold and +{scraps} Scraps recovered from debris."
