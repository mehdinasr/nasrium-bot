import random

class DuelEngine:
    """
    محاسبه‌گر نبردهای AI بر اساس سطح IXP و شانس کوانتومی.
    """
    @staticmethod
    def calculate_battle(p1_data, p2_data, bet_amount):
        p1_power = p1_data.get("intel_xp", 0)
        p2_power = p2_data.get("intel_xp", 0)
        
        # شانس پیروزی بر اساس قدرت (IXP)
        total_power = p1_power + p2_power
        if total_power == 0: return None, "Both AI cores are empty."
        
        p1_chance = p1_power / total_power
        roll = random.random()
        
        winner = p1_data if roll < p1_chance else p2_data
        loser = p2_data if roll < p1_chance else p1_data
        
        # انتقال IXP (مالیات امپراتوری ۵٪ در نبردها)
        tax = int(bet_amount * 0.05)
        win_amount = bet_amount - tax
        
        winner["intel_xp"] += win_amount
        loser["intel_xp"] -= bet_amount
        
        return {
            "winner_id": winner["user_id"],
            "win_amount": win_amount,
            "battle_log": f"AI Battle Finished. Winner: {winner['user_id']} (+{win_amount} IXP)"
        }
