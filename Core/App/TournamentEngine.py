import time

class TournamentEngine:
    # پاداش کل تورنمنت (توسط امپراتوری تامین می‌شود)
    PRIZE_POOL_NSM = 50000 

    @staticmethod
    def calculate_weekly_score(player_data):
        # این داده‌ها باید در فیلد‌های 'weekly_stats' ذخیره شوند
        weekly = player_data.get("weekly_stats", {"loot": 0, "wins": 0, "energy_spent": 0})
        
        score = (weekly["loot"] / 1000) + (weekly["wins"] * 50) + (weekly["energy_spent"] * 5)
        return int(score)

    @staticmethod
    def get_time_remaining():
        # شبیه‌سازی پایان هفته (هر یکشنبه)
        now = time.time()
        one_week = 604800
        remaining = one_week - (now % one_week)
        return int(remaining)
