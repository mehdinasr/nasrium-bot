class NexusEngine:
    # مقادیر مرجع برای تعادل جهانی
    TARGET_WIN_RATE = 0.65 # هدف: ۶۵٪ پیروزی در کل جهان
    
    @staticmethod
    def calculate_global_shift(all_players):
        total_wins = sum([p.get("raid_wins", 0) for p in all_players])
        total_losses = sum([p.get("raid_losses", 0) for p in all_players])
        total_raids = total_wins + total_losses
        
        current_win_rate = (total_wins / total_raids) if total_raids > 0 else 0.5
        
        # اگر نرخ پیروزی بالا باشد، ضریب نکسوس منفی می‌شود (افزایش سختی)
        # اگر نرخ پیروزی پایین باشد، ضریب مثبت می‌شود (کاهش سختی)
        shift = NexusEngine.TARGET_WIN_RATE - current_win_rate
        
        return {
            "win_rate": round(current_win_rate * 100, 1),
            "difficulty_adjustment": round(shift * 10, 2), # ضریب اصلاحی
            "state": "AGGRESSIVE" if shift < -0.05 else ("SUPPORTIVE" if shift > 0.05 else "BALANCED")
        }
