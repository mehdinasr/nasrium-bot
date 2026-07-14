class RankingEngine:
    @staticmethod
    def calculate_power_score(player_data):
        # فرمول رسمی قدرت ناصریوم
        th_lvl = player_data.get("town_hall_level", 1)
        troops = player_data.get("troops", 0)
        
        # محاسبه سطح کل تحقیقات
        research = player_data.get("research", {})
        total_tech_lvls = sum(research.values()) if research else 0
        
        # محاسبه ارزش آرتیفکت‌ها
        artifacts = len(player_data.get("artifacts", []))
        
        power_score = (th_lvl * 1000) + (troops * 2) + (total_tech_lvls * 500) + (artifacts * 2000)
        return int(power_score)

    @staticmethod
    def get_top_rankings(all_players):
        # مرتب‌سازی بازیکنان بر اساس قدرت
        ranked = []
        for p in all_players:
            score = RankingEngine.calculate_power_score(p)
            ranked.append({"user_id": p["user_id"], "power": score})
        
        return sorted(ranked, key=lambda x: x["power"], reverse=True)[:10]
