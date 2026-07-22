class ViralGrowthEngine:
    """مدیریت پاداش های چند لایه دعوت از دوستان."""
    @staticmethod
    def calculate_viral_bonus(depth):
        # پاداش تا 3 سطح عمق شبکه
        return 0.10 if depth == 1 else 0.05

class DailyPersistence:
    """مدیریت پاداش حضور متوالی در اکوسیستم."""
    @staticmethod
    def get_streak_bonus(days):
        return 1.0 + (days * 0.05)
