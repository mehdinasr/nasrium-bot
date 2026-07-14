class InsightEngine:
    @staticmethod
    def calculate_kpis(player_data):
        # ۱. محاسبه نرخ مرگباری در نبرد
        wins = player_data.get("raid_wins", 0)
        total_raids = wins + player_data.get("raid_losses", 0)
        lethality = (wins / total_raids * 100) if total_raids > 0 else 0
        
        # ۲. محاسبه راندمان استخراج (تخمینی)
        th_lvl = player_data.get("town_hall_level", 1)
        base_rate = th_lvl * 500
        # اعمال بونوس‌های تحقیقات و سندیکا (شبیه‌سازی)
        efficiency = 100 + (sum(player_data.get("research", {}).values()) * 5)
        
        # ۳. امتیاز هم‌افزایی AI
        evo_lvl = sum(player_data.get("ai_evolution", {}).values())
        synergy = min(100, evo_lvl * 10)

        return {
            "lethality": round(lethality, 1),
            "efficiency": efficiency,
            "synergy": synergy,
            "status": "ELITE" if lethality > 70 else "ACTIVE"
        }

    @staticmethod
    def get_ai_analysis(kpis):
        if kpis["lethality"] < 40:
            return "Commander, your military sector is underperforming. Focus on Forge upgrades."
        if kpis["synergy"] < 30:
            return "Neural link is weak. Dispatch your Agent to more Sync missions."
        return "All sectors operational. You are projecting peak Imperial power."
